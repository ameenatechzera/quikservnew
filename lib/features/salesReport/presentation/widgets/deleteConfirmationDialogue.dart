import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/delete_salesparameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String heading,
  required String message,
  required int salesMasterId,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(height: 12),

              // DYNAMIC HEADING
              Text(
                heading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // DYNAMIC MESSAGE
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('No'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: BlocConsumer<SalesReportCubit, SlesReportState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            context
                                .read<SalesReportCubit>()
                                .deleteSalesFromServer(
                                  SalesDeleteByMasterIdRequest(
                                    masterId: salesMasterId.toString(),
                                  ),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFF4B400),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
