import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/features/vat/presentation/screens/vat_creation_screen.dart';
import 'package:quikservnew/features/vat/presentation/widgets/vat_listing_widgets.dart';

class VatsListingScreen extends StatelessWidget {
  const VatsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: "Tax",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: VatCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: BlocConsumer<VatCubit, VatState>(
        listener: (context, state) {
          // Listen for deletion success
          if (state is VatDeleted) {
            showAnimatedToast(
              context,
              message: "Tax deleted successfully",
              isSuccess: true,
            );
          }

          // Listen for deletion errors
          if (state is VatDeleteError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is VatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VatError) {
            return Center(child: Text(state.error));
          }

          if (state is VatLoaded) {
            if (state.vat.vatDetails!.isEmpty) {
              return const Center(child: Text('No Tax found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.vat.vatDetails!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final vat = state.vat.vatDetails![index];
                return unitRow(
                  unitName: vat.vatName!,
                  onEdit: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: VatCreationScreen(
                        vatId: vat.vatId,
                        vatName: vat.vatName,
                        vatPercentage: vat.vatPercentage,
                      ),
                    );
                  },
                  onDelete: () {
                    showDeleteDialog(context, vat.vatId!);
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
