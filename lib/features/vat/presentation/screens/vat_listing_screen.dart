import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/vat/presentation/bloc/vat_cubit.dart';
import 'package:quikservnew/features/vat/presentation/screens/vat_creation_screen.dart';

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
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("VAT deleted successfully"),
            //     backgroundColor: Colors.green,
            //   ),
            // );
          }

          // Listen for deletion errors
          if (state is VatDeleteError) {
            showAnimatedToast(context, message: state.error, isSuccess: false);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            // );
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
                return _unitRow(
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
                    _showDeleteDialog(context, vat.vatId!);
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

  // 🔹 Single Unit Row
  Widget _unitRow({
    required String unitName,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        //border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              unitName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.edit, color: Colors.black54),
            onPressed: onEdit,
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  } // 🔹 Show confirmation dialog before deleting

  void _showDeleteDialog(BuildContext context, int vatId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Tax'),
        content: const Text('Are you sure you want to delete this VAT?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<VatCubit>().deleteVat(vatId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
