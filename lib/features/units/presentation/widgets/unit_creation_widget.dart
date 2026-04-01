import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/units/domain/parameters/save_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/parameters/update_unit_parameter.dart';
import 'package:quikservnew/features/units/presentation/bloc/unit_cubit.dart';

class UnitCreationWidget extends StatelessWidget {
  const UnitCreationWidget({
    super.key,
    required this.isEdit,
    required this.unitController,
    required this.unitId,
  });

  final bool isEdit;
  final TextEditingController unitController;
  final int? unitId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitCubit, UnitState>(
      listener: (context, state) {
        if (state is UnitSaved || state is UnitEdited) {
          showAnimatedToast(
            context,
            message: isEdit
                ? "Unit updated successfully"
                : "Unit added successfully",
            isSuccess: true,
          );
          Future.delayed(const Duration(milliseconds: 600), () {
            Navigator.pop(context);
          });
        }
        if (state is UnitSaveError || state is UnitEditError) {
          showAnimatedToast(
            context,
            message: (state as dynamic).error,
            isSuccess: false,
          );
        }
      },

      builder: (context, state) {
        final bool isLoading =
            state is UnitSaveLoading || state is UnitEditLoading;
        return SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // orange
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: isLoading
                ? null
                : () {
                    final unitName = unitController.text.trim();
                    if (unitName.isEmpty) {
                      showAnimatedToast(
                        context,
                        message: "Please enter a unit name",
                        isSuccess: false,
                      );
                      return;
                    }
                    if (isEdit) {
                      // ✏️ EDIT
                      context.read<UnitCubit>().editUnit(
                        unitId!,
                        EditUnitRequestModel(
                          unitName: unitName,
                          branchId: 1,
                          modifiedUser: 1,
                        ),
                      );
                    } else {
                      // 🔹 Trigger saveUnit Cubit
                      context.read<UnitCubit>().saveUnit(
                        SaveUnitRequestModel(
                          unitName: unitName,
                          branchId: 1,
                          createdUser: 1,
                        ),
                      );
                    }
                  },

            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save, size: 20),
            label: Text(
              isLoading
                  ? "Saving..."
                  : isEdit
                  ? "Update"
                  : "Add",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
