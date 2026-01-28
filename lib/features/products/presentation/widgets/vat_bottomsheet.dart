import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';

Future<void> showVatBottomSheet({
  required BuildContext context,
  required TextEditingController vatController,
  required void Function(int id, String name) onSelected,
}) async {
  final selectedVat = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Select VAT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),

                // VAT List
                Expanded(
                  child: BlocBuilder<VatCubit, VatState>(
                    builder: (context, state) {
                      if (state is VatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is VatLoaded) {
                        final vats = state.vat.vatDetails;
                        if (vats!.isEmpty) {
                          return const Center(child: Text("No VAT found"));
                        }

                        return ListView.separated(
                          controller: scrollController,
                          itemCount: vats.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final vat = vats[index];
                            final isSelected =
                                vatController.text == vat.vatName;

                            return ListTile(
                              title: Text(vat.vatName ?? 'Unnamed'),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : null,
                              onTap: () {
                                vatController.text = vat.vatName!;
                                onSelected(vat.vatId!, vat.vatName!);
                                Navigator.pop(ctx, vat.vatName);
                              },
                            );
                          },
                        );
                      } else if (state is VatError) {
                        return Center(child: Text("Error: ${state.error}"));
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),

                // Bottom drag hint
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  // Update controller in the calling screen
  if (selectedVat != null) {
    vatController.text = selectedVat;
  }
}
