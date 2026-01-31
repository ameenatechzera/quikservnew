import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/dayclose_report_cubit.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/screens/widgets/report_row.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class DailyClosingReportScreen extends StatefulWidget {
  DailyClosingReportScreen({super.key});

  @override
  State<DailyClosingReportScreen> createState() =>
      _DailyClosingReportScreenState();
}

class _DailyClosingReportScreenState extends State<DailyClosingReportScreen> {
  final TextEditingController fromDateController = TextEditingController();

  final TextEditingController toDateController = TextEditingController();

  DateTime fromDate = DateTime.now();

  String st_branchId = '';
  double dbl_salesTotal = 0, dbl_total = 0;
  DateTime toDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  final List<SummaryReports> summaryList = [];
  final List<ExpenseDetail> expenseList = [];
  final List<SummaryReport> itemsList = [];
  late DailyClosingReportResponse paymentList;
  String st_ExpenseTotal = '',
      st_CashBalance = '',
      st_BankBalance = '',
      st_salesTotal = '',
      st_SalesTotalItemWise = '';

  @override
  void initState() {
    super.initState();
    fetchSalesReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Daily Closing Report",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          _dateFilter(),
          const SizedBox(height: 20),
          BlocConsumer<DaycloseReportCubit, DaycloseReportState>(
            listener: (context, state) {
              if (state is DayCloseReportFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
              if (state is ItemWiseDetailsInitial) {
              } else if (state is ItemDetailsLoaded) {
                print('ItemDetailsLoaded ${state.itemWisReport}');
                itemsList.clear();
                itemsList.addAll(state.itemWisReport);

                st_SalesTotalItemWise = '';
                try {
                  for (int i = 0; i < itemsList.length; i++) {
                    dbl_salesTotal = double.parse(
                      itemsList[i].totalAmount.toString(),
                    );
                    dbl_total = dbl_total + dbl_salesTotal;
                    st_SalesTotalItemWise = dbl_total.toStringAsFixed(
                      get_decimalpoints(),
                    );
                  }
                } catch (_) {
                  print('calculation item sale total error');
                }
              } else if (state is DayCloseReportLoaded) {
                print('List ${state.dayCloseReport}');
                paymentList = state.dayCloseReport;

                summaryList.clear();
                summaryList.addAll(state.dayCloseReport.summaryReport);
                expenseList.clear();
                expenseList.addAll(state.dayCloseReport.expenseDetails);
                st_ExpenseTotal = state.dayCloseReport.expenseTotal;
                st_CashBalance = state.dayCloseReport.cashBalance;
                st_BankBalance = state.dayCloseReport.bankBalance;
              }
            },
            builder: (context, state) {
              if (state is DaycloseReportInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DayCloseReportLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: paymentList.summaryReport.length,
                          itemBuilder: (context, index) {
                            double dbl_salesTotal = 0;
                            final payment = paymentList.summaryReport[index];
                            double dbl_creditAmt = 0,
                                dbl_cashAmt = 0,
                                cbl_cardAmt = 0;
                            try {
                              dbl_creditAmt = double.parse(
                                payment.creditAmount,
                              );
                              dbl_cashAmt = double.parse(payment.cashAmount);
                              cbl_cardAmt = double.parse(payment.cardAmount);
                            } catch (_) {
                              print('null value salestotal parse conversion');
                            }
                            st_salesTotal = '';
                            dbl_salesTotal =
                                dbl_salesTotal +
                                (dbl_creditAmt + dbl_cashAmt + cbl_cardAmt);
                            st_salesTotal = dbl_salesTotal.toStringAsFixed(
                              get_decimalpoints(),
                            );

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8,
                              ),
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 6,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: appThemeLightOrange,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Sales Total',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              st_salesTotal,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LabelAmountRow(
                                            title: 'Cash',
                                            amount: payment.cashAmount,
                                          ),
                                        ),
                                        height10,

                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LabelAmountRow(
                                            title: 'Card',
                                            amount: payment.cardAmount,
                                          ),
                                        ),
                                        height10,

                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LabelAmountRow(
                                            title: 'Credit',
                                            amount: payment.creditAmount,
                                          ),
                                        ),
                                        //  height10,
                                        // const Divider(),
                                        Container(
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: appThemeLightOrange,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0),
                                              topRight: Radius.circular(0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Text(
                                                  ' Expense Total',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  4.0,
                                                ),
                                                child: Text(
                                                  st_ExpenseTotal,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              paymentList.expenseDetails.length,
                                          itemBuilder:
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                final expense = paymentList
                                                    .expenseDetails[index];
                                                return Container(
                                                  //height: 40,
                                                  decoration: const BoxDecoration(
                                                    //color: appThemeLightOrange,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      height5,

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4.0,
                                                            ),
                                                        child: LabelAmountRow(
                                                          title: expense
                                                              .ledgerName,
                                                          amount:
                                                              expense.amount,
                                                        ),
                                                      ),
                                                      height5,
                                                    ],
                                                  ),
                                                );
                                              },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Balance',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // height5,
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4.0,
                                            right: 4.0,
                                            bottom: 4.0,
                                          ),
                                          child: LabelAmountRow(
                                            title: 'Cash',
                                            amount: st_CashBalance,
                                          ),
                                        ),
                                        height5,

                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: LabelAmountRow(
                                            title: 'Card',
                                            amount: st_BankBalance,
                                          ),
                                        ),

                                        // LabelAmountRow(title: 'Expense Total', amount:'0.00') ,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: appThemeLightOrange,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          ' Product Wise',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          st_SalesTotalItemWise,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: itemsList.length,
                                  itemBuilder: (context, index) {
                                    final item_list = itemsList[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          4.0,
                                                        ),
                                                    child: Text(
                                                      item_list.productName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 2.0,
                                                  left: 4.0,
                                                  right: 4.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Qty',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          item_list.qty
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Sub',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          item_list.subTotal,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Tax',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          item_list.taxAmount,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  // return const SizedBox.shrink();

  // Expanded(
  //   flex: 1,
  //   child:
  //   BlocBuilder<DaycloseReportCubit, DaycloseReportState>(
  //     builder: (context, state) {
  //       double dbl_salesTotal = 0, dbl_total = 0;
  //       // if (state is ItemWiseReportInitial) {
  //       //   return const Center(child: CircularProgressIndicator());
  //       // }
  //        if (state is DayCloseReportFailure) {
  //         return Center(child: Text("Error: ${state.error}"));
  //       }
  //
  //       else if (state is DayCloseReportLoaded) {
  //         print('List ${state.dayCloseReport}');
  //         final paymentList = state.dayCloseReport;
  //
  //         summaryList.clear();
  //         summaryList.addAll(state.dayCloseReport.summaryReport);
  //         expenseList.clear();
  //         expenseList.addAll(state.dayCloseReport.expenseDetails);
  //         st_ExpenseTotal = state.dayCloseReport.expenseTotal;
  //         st_CashBalance = state.dayCloseReport.cashBalance;
  //         st_BankBalance = state.dayCloseReport.bankBalance;
  //         if (paymentList.summaryReport.isEmpty) {
  //           return const Center(child: Text("No data found."));
  //         }
  //         return ListView.builder(
  //           itemCount: paymentList.summaryReport.length,
  //           itemBuilder: (context, index) {
  //             double dbl_salesTotal = 0;
  //             final payment = paymentList.summaryReport[index];
  //             double dbl_creditAmt = 0,
  //                 dbl_cashAmt = 0,
  //                 cbl_cardAmt = 0;
  //             try {
  //               dbl_creditAmt = double.parse(payment.creditAmount);
  //               dbl_cashAmt = double.parse(payment.cashAmount);
  //               cbl_cardAmt = double.parse(payment.cardAmount);
  //             } catch (_) {
  //               print('null value salestotal parse conversion');
  //             }
  //             st_salesTotal = '';
  //             dbl_salesTotal =
  //                 dbl_salesTotal +
  //                 (dbl_creditAmt + dbl_cashAmt + cbl_cardAmt);
  //             st_salesTotal = dbl_salesTotal.toStringAsFixed(
  //               get_decimalpoints(),
  //             );
  //
  //             return Padding(
  //               padding: const EdgeInsets.only(left: 8.0, right: 8),
  //               child: Card(
  //                 elevation: 5,
  //                 margin: const EdgeInsets.symmetric(
  //                   vertical: 6,
  //                   horizontal: 6,
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                       height: 40,
  //                       decoration: const BoxDecoration(
  //                         color: appThemeLightOrange,
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(10),
  //                           topRight: Radius.circular(10),
  //                         ),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(
  //                           left: 10,
  //                           right: 10,
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text(
  //                               'Sales Total',
  //                               style: TextStyle(
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                               st_salesTotal,
  //                               style: const TextStyle(
  //                                 fontSize: 18,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Column(
  //                       mainAxisAlignment:
  //                           MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(4.0),
  //                           child: LabelAmountRow(
  //                             title: 'Cash',
  //                             amount: payment.cashAmount,
  //                           ),
  //                         ),
  //                         height10,
  //
  //                         Padding(
  //                           padding: const EdgeInsets.all(4.0),
  //                           child: LabelAmountRow(
  //                             title: 'Card',
  //                             amount: payment.cardAmount,
  //                           ),
  //                         ),
  //                         height10,
  //
  //                         Padding(
  //                           padding: const EdgeInsets.all(4.0),
  //                           child: LabelAmountRow(
  //                             title: 'Credit',
  //                             amount: payment.creditAmount,
  //                           ),
  //                         ),
  //                         //  height10,
  //                         // const Divider(),
  //                         Container(
  //                           height: 40,
  //                           decoration: const BoxDecoration(
  //                             color: appThemeLightOrange,
  //                             borderRadius: BorderRadius.only(
  //                               topLeft: Radius.circular(0),
  //                               topRight: Radius.circular(0),
  //                             ),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment:
  //                                 MainAxisAlignment.spaceBetween,
  //                             crossAxisAlignment:
  //                                 CrossAxisAlignment.start,
  //                             children: [
  //                               const Padding(
  //                                 padding: EdgeInsets.all(4.0),
  //                                 child: Text(
  //                                   ' Expense Total',
  //                                   style: TextStyle(
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.all(4.0),
  //                                 child: Text(
  //                                   st_ExpenseTotal,
  //                                   style: const TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 18,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         ListView.builder(
  //                           shrinkWrap: true,
  //                           physics:
  //                               const NeverScrollableScrollPhysics(),
  //                           itemCount:
  //                               paymentList.expenseDetails.length,
  //                           itemBuilder:
  //                               (BuildContext context, int index) {
  //                                 final expense =
  //                                     paymentList.expenseDetails[index];
  //                                 return Container(
  //                                   //height: 40,
  //                                   decoration: const BoxDecoration(
  //                                     //color: appThemeLightOrange,
  //                                     borderRadius: BorderRadius.only(
  //                                       topLeft: Radius.circular(10),
  //                                       topRight: Radius.circular(10),
  //                                     ),
  //                                   ),
  //                                   child: Column(
  //                                     children: [
  //                                       height5,
  //
  //                                       Padding(
  //                                         padding: const EdgeInsets.all(
  //                                           4.0,
  //                                         ),
  //                                         child: LabelAmountRow(
  //                                           title: expense.ledgerName,
  //                                           amount: expense.amount,
  //                                         ),
  //                                       ),
  //                                       height5,
  //                                     ],
  //                                   ),
  //                                 );
  //                               },
  //                         ),
  //                         const Padding(
  //                           padding: EdgeInsets.all(4.0),
  //                           child: Row(
  //                             mainAxisAlignment:
  //                                 MainAxisAlignment.center,
  //                             crossAxisAlignment:
  //                                 CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 'Balance',
  //                                 style: TextStyle(
  //                                   fontSize: 18,
  //                                   color: Colors.red,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //
  //                         // height5,
  //                         Padding(
  //                           padding: const EdgeInsets.only(
  //                             left: 4.0,
  //                             right: 4.0,
  //                             bottom: 4.0,
  //                           ),
  //                           child: LabelAmountRow(
  //                             title: 'Cash',
  //                             amount: st_CashBalance,
  //                           ),
  //                         ),
  //                         height5,
  //
  //                         Padding(
  //                           padding: const EdgeInsets.all(4.0),
  //                           child: LabelAmountRow(
  //                             title: 'Card',
  //                             amount: st_BankBalance,
  //                           ),
  //                         ),
  //
  //                         // LabelAmountRow(title: 'Expense Total', amount:'0.00') ,
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //       else {
  //         return const Center(child: Text("Please select date range"));
  //       }
  //     },
  //   ),
  // ),
  // Expanded(
  //   flex: 1,
  //   child: BlocBuilder<DaycloseReportCubit, DaycloseReportState>(
  //     builder: (context, state) {
  //       double dbl_salesTotal = 0, dbl_total = 0;
  //
  //       if (state is ItemWiseDetailsInitial) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (state is ItemDetailsFailure) {
  //         return Center(child: Text("Error: ${state.error}"));
  //       }
  //       else if (state is ItemDetailsLoaded) {
  //         print('ItemDetailsLoaded ${state.itemWisReport}');
  //         itemsList.clear();
  //         itemsList.addAll(state.itemWisReport);
  //
  //         final itemList = state.itemWisReport;
  //         if (itemList.isEmpty) {
  //           return const Center(child: Text("No data found."));
  //         } else {
  //           st_SalesTotalItemWise = '';
  //           try {
  //             for (int i = 0; i < itemList.length; i++) {
  //               dbl_salesTotal = double.parse(
  //                 itemList[i].totalAmount.toString(),
  //               );
  //               dbl_total = dbl_total + dbl_salesTotal;
  //               st_SalesTotalItemWise = dbl_total.toStringAsFixed(
  //                 get_decimalpoints(),
  //               );
  //             }
  //           } catch (_) {
  //             print('calculation item sale total error');
  //           }
  //         }
  //
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Card(
  //             elevation: 5,
  //             margin: const EdgeInsets.symmetric(
  //               vertical: 6,
  //               horizontal: 6,
  //             ),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   height: 40,
  //                   decoration: const BoxDecoration(
  //                     color: appThemeLightOrange,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(8),
  //                       topRight: Radius.circular(8),
  //                     ),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Padding(
  //                         padding: EdgeInsets.all(4.0),
  //                         child: Text(
  //                           ' Product Wise',
  //                           style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(4.0),
  //                         child: Text(
  //                           st_SalesTotalItemWise,
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemCount: itemList.length,
  //                   itemBuilder: (context, index) {
  //                     final item_list = itemList[index];
  //                     return Column(
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(4),
  //                           child: Column(
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment:
  //                                     MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Padding(
  //                                     padding: const EdgeInsets.all(
  //                                       4.0,
  //                                     ),
  //                                     child: Text(
  //                                       item_list.productName,
  //                                       style: const TextStyle(
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(
  //                                   top: 4.0,
  //                                   bottom: 2.0,
  //                                   left: 4.0,
  //                                   right: 4.0,
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         const Text(
  //                                           'Qty',
  //                                           style: TextStyle(
  //                                             fontSize: 13,
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           item_list.qty.toString(),
  //                                           style: const TextStyle(
  //                                             fontWeight:
  //                                                 FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         const Text(
  //                                           'Sub',
  //                                           style: TextStyle(
  //                                             fontSize: 13,
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           item_list.subTotal,
  //                                           style: const TextStyle(
  //                                             fontWeight:
  //                                                 FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         const Text(
  //                                           'Tax',
  //                                           style: TextStyle(
  //                                             fontSize: 13,
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           item_list.taxAmount,
  //                                           style: const TextStyle(
  //                                             fontWeight:
  //                                                 FontWeight.bold,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   ),
  // ),

  Future<void> pickDate({required bool isFrom}) async {
    print('reached SalesReport');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      fetchSalesReport();
    }
  }

  Widget _dateBox(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? "Select Date"
                        : "${date.day.toString().padLeft(2, '0')}-"
                              "${date.month.toString().padLeft(2, '0')}-"
                              "${date.year}",
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 API / DB CALL
  Future<void> fetchSalesReport() async {
    final sharedPrefHelper = SharedPreferenceHelper();
    st_branchId = await sharedPrefHelper.getBranchId();

    // context.read<ItemWiseReportCubit>().fetchItemWiseReport(
    //   ItemWiseReportRequest(
    //     FromDate: formatter.format(fromDate),
    //     ToDate: formatter.format(toDate),
    //     branchId: st_branchId,
    //   ),
    // );

    context.read<DaycloseReportCubit>().fetchItemWiseReport(
      ItemWiseReportRequest(
        FromDate: formatter.format(fromDate),
        ToDate: formatter.format(toDate),
        branchId: st_branchId,
      ),
    );

    context.read<DaycloseReportCubit>().fetchDayCloseReport(
      DailyCloseReportRequest(
        FromDate: formatter.format(fromDate),
        ToDate: formatter.format(toDate),
        branchId: st_branchId,
      ),
    );
  }

  int get_decimalpoints() {
    final int decimal_points = 2;
    return decimal_points;
  }

  /// 🔹 Date Filter
  Widget _dateFilter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFF4CC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _dateBox(
              "From Date",
              fromDate,
              () => pickDate(isFrom: true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _dateBox("To Date", toDate, () => pickDate(isFrom: false)),
          ),
        ],
      ),
    );
  }
}
