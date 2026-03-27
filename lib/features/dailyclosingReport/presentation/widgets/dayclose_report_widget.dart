import 'package:flutter/material.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyclosingreport_result.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/widgets/report_row.dart';

class DayCloseReportWidget extends StatelessWidget {
  const DayCloseReportWidget({
    super.key,
    required this.st_salesTotal,
    required this.payment,
    required this.st_ExpenseTotal,
    required this.paymentList,
    required this.st_CashBalance,
    required this.st_BankBalance,
  });

  final String st_salesTotal;
  final SummaryReports payment;
  final String st_ExpenseTotal;
  final DailyClosingReportResponse paymentList;
  final String st_CashBalance;
  final String st_BankBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: const EdgeInsets.all(4.0),
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
                              amount: expense.amount,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: LabelAmountRow(title: 'Cash', amount: st_CashBalance),
                ),
                height5,

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: LabelAmountRow(title: 'Card', amount: st_BankBalance),
                ),

                // LabelAmountRow(title: 'Expense Total', amount:'0.00') ,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
