import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/widgets/subscriptionService.dart';
import 'package:quikservnew/features/settings/presentation/widgets/daily_task_settings.dart';
import 'package:quikservnew/features/settings/presentation/widgets/settings_card.dart';
import 'package:quikservnew/features/settings/presentation/widgets/subscription_infocard.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

String st_companyName = '';
String vatType = '';
bool vatStatus = true;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<String?> _getAppVersion() async {
    vatType = await SharedPreferenceHelper().getVatType();
    if (vatType == 'true') {
      vatStatus = true;
    } else {
      vatStatus = false;
    }
    return await SharedPreferenceHelper().getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    DailyTaskHelper.runOncePerDay(
      taskKey: "subscription_check",
      task: () async {
        final code = await SharedPreferenceHelper().getSubscriptionCode();
        context.read<RegisterCubit>().registerServer(
          RegisterServerRequest(slno: code),
        );
      },
    );
    return FutureBuilder<String?>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        final appVersion = 'basic';
        final bool isBasic = appVersion.toLowerCase() == "basic";
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            title: const Text(
              "Configurations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.theme,
          ),
          body: Column(
            children: [
              SubscriptionInfoCard(), // 👈 top card
              SettingsCard(isBasic: isBasic),
              BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) async {
                  if (state is RegisterSuccess) {
                    SubscriptionService.validateSubscription(context);
                    // //  EXPIRY CHECK FIRST (BEFORE ANYTHING)
                    // final expired = await isLicenseExpired();
                    // if (expired) {
                    //   showExpiryDialog(context);
                    //   // isProcessing.value = false;
                    //   return; //  STOP EVERYTHING
                    // }
                  }
                },

                builder: (context, state) {
                  return Container();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
