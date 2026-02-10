import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/database/app_database.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';
import 'package:quikservnew/features/accountGroups/presentation/bloc/account_group_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/logincubit/login_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/screens/splash_screen.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/groups/presentation/bloc/groups_cubit.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/bloc/payment_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/services/service_locator.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

import 'features/dailyclosingReport/presentation/bloc/dayclose_report_cubit.dart';
import 'features/itemwiseReport/presentation/bloc/item_wise_report_cubit.dart';
import 'features/masters/presentation/bloc/user_creation_cubit.dart';

late final AppDatabase appDb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.theme,
      statusBarIconBrightness: Brightness.dark,
      //statusBarBrightness: Brightness.dark,
    ),
  );
  appDb = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  await ServiceLocator.init();
  final sharedPrefHelper = SharedPreferenceHelper();

  // set the default URL if not already set
  final currentBaseUrl = await sharedPrefHelper.getBaseUrl();
  if (currentBaseUrl == null) {
    await sharedPrefHelper.setBaseUrl(
      'https://techzera.in/quikSERV_Api/public/api',
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterCubit>(create: (_) => sl<RegisterCubit>()),
        BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
        BlocProvider<UnitCubit>(create: (_) => sl<UnitCubit>()..fetchUnits()),
        BlocProvider<VatCubit>(create: (_) => sl<VatCubit>()..fetchVat()),
        BlocProvider<GroupsCubit>(
          create: (_) => sl<GroupsCubit>()..fetchGroups(),
        ),
        BlocProvider<ProductCubit>(create: (_) => sl<ProductCubit>()),
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
        BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
        BlocProvider<SaleCubit>(create: (_) => sl<SaleCubit>()),
        BlocProvider<SalesReportCubit>(create: (_) => sl<SalesReportCubit>()),
        BlocProvider<UserCreationCubit>(create: (_) => sl<UserCreationCubit>()),
        BlocProvider<AccountledgerCubit>(
          create: (_) => sl<AccountledgerCubit>(),
        ),
        BlocProvider<ItemWiseReportCubit>(
          create: (_) => sl<ItemWiseReportCubit>(),
        ),
        BlocProvider<DaycloseReportCubit>(
          create: (_) => sl<DaycloseReportCubit>(),
        ),
        BlocProvider<AccountGroupCubit>(create: (_) => sl<AccountGroupCubit>()),
        BlocProvider<PaymentCubit>(create: (_) => sl<PaymentCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuikSERV',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.theme,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
