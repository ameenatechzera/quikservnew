import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/pdf.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/print_thermal.dart';

class SalesReportRow extends StatelessWidget {
  const SalesReportRow({super.key, required this.selectPrintStatus});

  final bool selectPrintStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: false,
          child: Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 2.0,
                right: 2.0,
                bottom: 2.0,
                top: 12.0,
              ),
              child: Container(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      appBarColor,
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      appBarColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: appBarColor),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    print('pressed');
                    if (clickPdfFlag == 0) {
                      Fluttertoast.showToast(
                        msg: "Generate new pdf before share!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      //await sharePdf();
                    }
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: selectPrintStatus,
          child: Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 2.0,
                right: 2.0,
                bottom: 2.0,
                top: 12.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAB307),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (saleList.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "No data available to share",
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                            );
                            return;
                          }

                          try {
                            await SalesPreviewPdfHelper.createPdf(
                              saleList.first,
                            );
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: "Failed to generate PDF",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        child: const Text(
                          'Share',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10), // spacing between buttons

                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAB307),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrintPage(
                                pageFrom: 'SalesReport',
                                sales: saleList.first,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Print',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
