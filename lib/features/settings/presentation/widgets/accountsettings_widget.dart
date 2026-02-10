// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';

// /// -------- INPUT FIELD UI --------
// class InputField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;

//   const InputField({super.key, required this.label, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           readOnly: true, // 🔑 important
//           onTap: () => _showBankLedgerBottomSheet(context),
//           decoration: const InputDecoration(
//             isDense: true,
//             border: UnderlineInputBorder(),
//             suffixIcon: Icon(Icons.keyboard_arrow_down),
//           ),
//         ),
//       ],
//     );
//   }

//   /// 🔹 BottomSheet
//   void _showBankLedgerBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         // fetch when opened
//         context.read<AccountledgerCubit>().fetchBankAccountLedger(
//           groupIds: [5, 6],
//         );

//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.7,
//           child: BlocBuilder<AccountledgerCubit, AccountledgerState>(
//             builder: (context, state) {
//               if (state is AccountledgerLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state is AccountledgerError) {
//                 return Center(child: Text(state.error));
//               }

//               if (state is BankAccountLedgerLoaded) {
//                 final ledgers = state.bankAccountLedger.data;

//                 return ListView.separated(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: ledgers!.length,
//                   separatorBuilder: (_, __) => const Divider(),
//                   itemBuilder: (context, index) {
//                     final ledger = ledgers[index];

//                     return ListTile(
//                       leading: const Icon(Icons.account_balance),
//                       title: Text(
//                         ledger.bankAccName ?? ledger.ledgerName ?? 'Unnamed',
//                       ),
//                       subtitle: Text(ledger.bankName ?? ''),
//                       onTap: () {
//                         // ✅ set selected value
//                         controller.text =
//                             ledger.bankAccName ?? ledger.ledgerName ?? '';

//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 );
//               }

//               return const SizedBox.shrink();
//             },
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/accountledger/domain/entities/fetch_bankledger_entity.dart';
import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onTap; // 🔹 allow parent to handle tap

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(),
            suffixIcon: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }
}

Future<FetchBankAccountLedgerDetailsEntity?> showBankLedgerBottomSheet(
  BuildContext context,
) {
  return showModalBottomSheet<FetchBankAccountLedgerDetailsEntity>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      context.read<AccountledgerCubit>().fetchBankAccountLedger(
        groupIds: [5, 6],
        branchId: 1,
      );

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: BlocBuilder<AccountledgerCubit, AccountledgerState>(
          builder: (context, state) {
            if (state is AccountledgerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AccountledgerError) {
              return Center(child: Text(state.error));
            }
            if (state is BankAccountLedgerLoaded) {
              final ledgers = state.bankAccountLedger.data ?? [];

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: ledgers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final ledger = ledgers[index];
                  return ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(
                      ledger.bankAccName ?? ledger.ledgerName ?? 'Unnamed',
                    ),
                    subtitle: Text(ledger.bankName ?? ''),
                    onTap: () {
                      Navigator.pop(
                        context,
                        ledger,
                      ); // 🔹 return selected ledger
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      );
    },
  );
}
