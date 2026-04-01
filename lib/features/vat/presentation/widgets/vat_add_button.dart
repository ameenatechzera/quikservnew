import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';

class VatAddButton extends StatelessWidget {
  const VatAddButton({
    super.key,
    required this.isEdit,
    required this.vatNameController,
    required this.vatPercentageController,
    required this.vatId,
  });

  final bool isEdit;
  final TextEditingController vatNameController;
  final TextEditingController vatPercentageController;
  final int? vatId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VatCubit, VatState>(
      listener: (context, state) {
        if (state is VatAdded || state is VatEdited) {
          showAnimatedToast(
            context,
            message: isEdit
                ? "TAX updated successfully!"
                : "TAX added successfully!",
            isSuccess: true,
          );

          Navigator.pop(context);
        }

        if (state is VatAddError || state is VatEditError) {
          showAnimatedToast(
            context,
            message: state is VatAddError
                ? state.error
                : (state as VatEditError).error,
            isSuccess: false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is VatAddLoading || state is VatEditLoading;

        return SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: isLoading
                ? null
                : () {
                    final vatName = vatNameController.text.trim();
                    final vatPercentageText = vatPercentageController.text
                        .trim();

                    if (vatName.isEmpty || vatPercentageText.isEmpty) {
                      showAnimatedToast(
                        context,
                        message: "Please fill all fields",
                        isSuccess: false,
                      );
                      return;
                    }
                    final vatPercentage = int.tryParse(vatPercentageText);
                    if (vatPercentage == null) {
                      showAnimatedToast(
                        context,
                        message: "Enter valid TAX percentage",
                        isSuccess: false,
                      );
                      return;
                    }
                    if (isEdit) {
                      //  EDIT VAT
                      context.read<VatCubit>().updateVat(
                        vatId!,
                        EditVatRequestModel(
                          vatName: vatName,
                          vatPercentage: vatPercentage,
                          branchId: 1,
                          modifiedUser: 1,
                        ),
                      );
                    } else {
                      // Trigger Add VAT
                      context.read<VatCubit>().addVat(
                        AddVatRequestModel(
                          vatName: vatName,
                          vatPercentage: vatPercentage,
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
