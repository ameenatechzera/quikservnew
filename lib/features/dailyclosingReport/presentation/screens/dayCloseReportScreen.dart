import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/parameters/dailyClosingReportRequest.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/bloc/dayclose_report_cubit.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/screens/widgets/report_row.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';

final List<SummaryReports> summaryList=[];
final List<ExpenseDetail> expenseList=[];
final List<SummaryReport> itemsList=[];
String st_ExpenseTotal ='', st_CashBalance ='', st_BankBalance ='' , st_salesTotal ='' , st_SalesTotalItemWise ='' ;
class DailyClosingReport extends StatelessWidget {
  DailyClosingReport({super.key});

  final TextEditingController dateController = TextEditingController();
  final ValueNotifier<bool> hasSelectedDate = ValueNotifier(false);
  final ValueNotifier<DateTime> selectedDateNotifier =
  ValueNotifier<DateTime>(DateTime.now());

  void _onDateChanged(BuildContext context) {
    final selectedDate = dateController.text.trim();
    print('selectedDate $selectedDate');

    if (selectedDate.isNotEmpty) {
      hasSelectedDate.value = true;

      context.read<DaycloseReportCubit>().fetchItemWiseReport(
        ItemWiseReportRequest(
           FromDate: selectedDate, ToDate: selectedDate, branchId: "1",
        ),
      );

      context.read<DaycloseReportCubit>().fetchDayCloseReport(
        DailyCloseReportRequest(
          FromDate: selectedDate,
          ToDate: selectedDate,
          branchId: '',
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDateNotifier.value = picked;
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      dateController.text = formatted;
      _onDateChanged(context);
    }
  }

  @override
  Widget build(BuildContext context) {
   // context.read<AppbarCubit>().dailyClosingReportPageSelected();

    if (dateController.text.isEmpty) {
      final today = DateTime.now();
      final formatted = DateFormat('yyyy-MM-dd').format(today);
      dateController.text = formatted;

      Future.microtask(() => _onDateChanged(context));
    }

    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<DateTime>(
            valueListenable: selectedDateNotifier,
            builder: (context, selectedDate, _) {
              return Container(
                width: double.infinity,
                height: 50,
                color: appBarColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final previous =
                        selectedDate.subtract(const Duration(days: 1));
                        selectedDateNotifier.value = previous;
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(previous);
                        _onDateChanged(context);
                      },
                      child: const Text(
                        '<',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final next =
                        selectedDate.add(const Duration(days: 1));
                        selectedDateNotifier.value = next;
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(next);
                        _onDateChanged(context);
                      },
                      child: const Text(
                        '>',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: hasSelectedDate,
              builder: (context, value, _) {
                if (!value) {
                  return const Center(
                      child: Text("Select a date to view the report."));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item-wise Report
                      const Center(),
                      BlocBuilder<DaycloseReportCubit, DaycloseReportState>(
                        builder: (context, state) {
                          // if(state is DayCloseReportPrintSelected){
                          //
                          //   String formatedDate = formatDateString(dateController.text.toString());
                          //   print('formatedDate $formatedDate');
                          //
                          //   Future.delayed(Duration(seconds: 0), () {
                          //     Navigator.pushAndRemoveUntil(
                          //       context,
                          //       MaterialPageRoute(builder: (context) => PrintPage(pageFrom: 'DailyClosingReport',
                          //         expenseList: expenseList,summaryList: summaryList,itemsList:itemsList,cashBalance: st_CashBalance,
                          //         bankBalance: st_BankBalance,expenseTotal: st_ExpenseTotal,salesTotal: st_salesTotal,itemWiseSalesTotal: st_SalesTotalItemWise,
                          //         dailyCloseReportDate: formatedDate,)),
                          //           (Route<dynamic> route) => false, // removes all previous routes
                          //     );
                          //
                          //   });
                          // }
                          if (state is DaycloseReportInitial) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is DayCloseReportFailure) {
                            return Center(
                                child: Text("Error: ${state.error}"));
                          } else if (state is DayCloseReportLoaded) {

                            final paymentList = state.dayCloseReport;

                            summaryList.clear();
                            summaryList.addAll(state.dayCloseReport.summaryReport);
                            expenseList.clear();
                            expenseList.addAll(state.dayCloseReport.expenseDetails);
                            st_ExpenseTotal = state.dayCloseReport.expenseTotal;
                            st_CashBalance = state.dayCloseReport.cashBalance;
                            st_BankBalance = state.dayCloseReport.bankBalance;
                            if (paymentList.summaryReport.isEmpty) {
                              return const Center(
                                  child: Text("No data found."));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paymentList.summaryReport.length,
                              itemBuilder: (context, index) {
                                double dbl_salesTotal = 0;
                                final payment = paymentList.summaryReport[index];
                                double dbl_creditAmt = 0,dbl_cashAmt =0 , cbl_cardAmt =0;
                                try {
                                  dbl_creditAmt = double.parse(
                                      payment.creditAmount);
                                  dbl_cashAmt = double.parse(
                                      payment.cashAmount);
                                  cbl_cardAmt = double.parse(
                                      payment.cardAmount);
                                }catch(_){
                                  print('null value salestotal parse conversion');
                                }
                                st_salesTotal = '';
                                dbl_salesTotal = dbl_salesTotal + (dbl_creditAmt + dbl_cashAmt + cbl_cardAmt);
                                st_salesTotal = dbl_salesTotal.toStringAsFixed(get_decimalpoints());


                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 6),
                                      child: Column(children: [
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
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Sales Total',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  st_salesTotal,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
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
                                                  amount: payment.cardAmount),
                                            ),
                                            height10,

                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: LabelAmountRow(
                                                  title: 'Credit',
                                                  amount: payment.creditAmount),
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
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Text(
                                                      ' Expense Total',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(st_ExpenseTotal,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: paymentList.expenseDetails.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final expense = paymentList.expenseDetails[index];
                                                return Container(
                                                  //height: 40,
                                                  decoration: const BoxDecoration(
                                                    //color: appThemeLightOrange,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [

                                                      height5,

                                                      Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: LabelAmountRow(
                                                            title: expense.ledgerName,
                                                            amount: expense.amount),
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
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    'Balance',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.red,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // height5,

                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,right: 4.0,bottom: 4.0),
                                              child: LabelAmountRow(
                                                  title: 'Cash',
                                                  amount: st_CashBalance),
                                            ),
                                            height5,

                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: LabelAmountRow(
                                                  title: 'Card',
                                                  amount: st_BankBalance),
                                            ),

                                            // LabelAmountRow(title: 'Expense Total', amount:'0.00') ,

                                          ],
                                        ),
                                      ])),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      BlocBuilder<DaycloseReportCubit, DaycloseReportState>(
                        builder: (context, state) {
                          double dbl_salesTotal = 0, dbl_total = 0;

                          if (state is ItemDetailsLoaded) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is ItemDetailsFailure) {
                            return Center(
                                child: Text("Error: ${state.error}"));
                          } else if (state is ItemDetailsLoaded) {
                            itemsList.clear();
                            itemsList.addAll(state.itemWisReport);

                            final itemList = state.itemWisReport;
                            if (itemList.isEmpty) {
                              return const Center(
                                  child: Text("No data found."));
                            }
                            else{
                              st_SalesTotalItemWise ='';
                              try{
                                for(int i =0;i<itemList.length;i++) {
                                  dbl_salesTotal = double.parse(
                                      itemList[i].totalAmount.toString());
                                  dbl_total = dbl_total + dbl_salesTotal;
                                  st_SalesTotalItemWise = dbl_total.toStringAsFixed(
                                      get_decimalpoints());
                                }
                              }catch(_){
                                print('calculation item sale total error');
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 6),
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
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              ' Product Wise',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(st_SalesTotalItemWise,
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: 18)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: itemList.length,
                                      itemBuilder: (context, index) {
                                        final item_list = itemList[index];
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
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Text(
                                                            item_list.productName,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),

                                                      ]),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0,bottom: 2.0,left: 4.0,right: 4.0),
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
                                                            Text( item_list.qty.toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold
                                                                )),
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
                                                            Text( item_list.subTotal,
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold)),
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
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  String formatDateString(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    return formattedDate;
  }
  int get_decimalpoints() {
    final int decimal_points = 2;
    return decimal_points;
  }

}
