import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/units/presentation/helper/unit_creation_helper.dart';
import 'package:quikservnew/features/units/presentation/screens/unit_creation_screen.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';

class UnitsListingScreen extends StatelessWidget {
  UnitsListingScreen({super.key});
  final UnitCreationHelper helper = UnitCreationHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(
        title: "Units",

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black, size: 28),
            onPressed: () {
              AppNavigator.pushSlide(
                context: context,
                page: UnitCreationScreen(),
              );
            },
          ),
        ],
      ),

      body: BlocConsumer<UnitCubit, UnitState>(
        listener: (context, state) {
          if (state is UnitDeleted) {
            showAnimatedToast(
              context,
              message: 'Unit Deleted Successfully',
              isSuccess: true,
            );
            // 🔄 Refresh list
            context.read<UnitCubit>().fetchUnits();
          }

          if (state is UnitDeleteError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
          }
        },
        builder: (context, state) {
          if (state is UnitLoading || state is UnitDeleteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnitError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is UnitLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.units.details!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final unit = state.units.details![index];
                return helper.unitRow(
                  unitName: unit.unitName!,
                  onEdit: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: UnitCreationScreen(
                        unitId: unit.unitId,
                        unitName: unit.unitName,
                      ),
                    );
                  },
                  onDelete: () {
                    helper.showDeleteConfirmDialog(
                      context: context,
                      unitId: unit.unitId!,
                    );
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
