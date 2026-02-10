import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';

class VatCreationScreen extends StatelessWidget {
  final int? vatId;
  final String? vatName;
  final int? vatPercentage;
  VatCreationScreen({super.key, this.vatId, this.vatName, this.vatPercentage});

  final TextEditingController vatNameController = TextEditingController();
  final TextEditingController vatPercentageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Prefill when edit
    if (vatName != null && vatNameController.text.isEmpty) {
      vatNameController.text = vatName!;
    }
    if (vatPercentage != null && vatPercentageController.text.isEmpty) {
      vatPercentageController.text = vatPercentage.toString();
    }

    final bool isEdit = vatId != null;
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CommonAppBar(title: isEdit ? "Edit TAX" : "Add TAX"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 VAT Name
            TextField(
              controller: vatNameController,
              decoration: const InputDecoration(
                labelText: "TAX Type",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🔹 VAT Percentage
            TextField(
              controller: vatPercentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "TAX Percentage",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // 🔹 Add VAT Button
            BlocConsumer<VatCubit, VatState>(
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
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       state is VatAddError
                  //           ? state.error
                  //           : (state as VatEditError).error,
                  //     ),
                  //     backgroundColor: Colors.red,
                  //   ),
                  // );
                }
              },
              builder: (context, state) {
                final isLoading =
                    state is VatAddLoading || state is VatEditLoading;

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
                            final vatPercentageText = vatPercentageController
                                .text
                                .trim();

                            if (vatName.isEmpty || vatPercentageText.isEmpty) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text("Please fill all fields"),
                              //     backgroundColor: Colors.orange,
                              //   ),
                              // );
                              showAnimatedToast(
                                context,
                                message: "Please fill all fields",
                                isSuccess: false,
                              );
                              return;
                            }

                            // ⚠️ Keep the type as in model (int or String)
                            final vatPercentage = int.tryParse(
                              vatPercentageText,
                            );
                            if (vatPercentage == null) {
                              showAnimatedToast(
                                context,
                                message: "Enter valid TAX percentage",
                                isSuccess: false,
                              );
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text("Enter valid VAT percentage"),
                              //     backgroundColor: Colors.red,
                              //   ),
                              // );
                              return;
                            }
                            if (isEdit) {
                              // ✏️ EDIT VAT
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
