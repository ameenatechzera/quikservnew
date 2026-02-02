// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quikservnew/features/accountledger/presentation/bloc/accountledger_cubit.dart';

// void showBankLedgerBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (context) {
//       // 🔹 Fetch bank ledger when bottom sheet opens
//       context.read<AccountledgerCubit>().fetchBankAccountLedger(
//         groupIds: [5, 6],
//       );

//       return SizedBox(
//         height: MediaQuery.of(context).size.height * 0.7,
//         child: BlocBuilder<AccountledgerCubit, AccountledgerState>(
//           builder: (context, state) {
//             if (state is AccountledgerLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is AccountledgerError) {
//               return Center(child: Text(state.error));
//             } else if (state is BankAccountLedgerLoaded) {
//               final bankLedgers = state.bankAccountLedger.data;

//               if (bankLedgers!.isEmpty) {
//                 return const Center(
//                   child: Text("No bank account ledger found."),
//                 );
//               }

//               return ListView.separated(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: bankLedgers.length,
//                 separatorBuilder: (_, __) => const Divider(),
//                 itemBuilder: (context, index) {
//                   final ledger = bankLedgers[index];
//                   return ListTile(
//                     leading: const Icon(Icons.account_balance),
//                     title: Text(
//                       ledger.bankAccName ?? ledger.ledgerName ?? "No Name",
//                     ),
//                     subtitle: Text(
//                       "Bank: ${ledger.bankName ?? '-'}\nIBAN: ${ledger.ibanNo ?? '-'}",
//                     ),
//                     trailing: Text(
//                       ledger.openingBalance ?? "0",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     onTap: () {
//                       // 🔹 Do something on tap, e.g., select this ledger
//                       Navigator.pop(context, ledger);
//                     },
//                   );
//                 },
//               );
//             } else {
//               return const SizedBox.shrink();
//             }
//           },
//         ),
//       );
//     },
//   );
// }
