// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:quikservnew/core/theme/colors.dart';
// import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
// import 'package:quikservnew/features/salesReport/domain/entities/salesreport_result.dart';
// import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
// import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
// import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';
// import 'package:quikservnew/features/salesReport/presentation/widgets/delete_confirmation_dialogue.dart';
// import 'package:quikservnew/features/salesReport/presentation/widgets/salesreport_widgets.dart';
// import 'package:quikservnew/services/shared_preference_helper.dart';
// import 'package:share_plus/share_plus.dart';

// class SalesReportPage extends StatefulWidget {
//   const SalesReportPage({super.key});

//   @override
//   State<SalesReportPage> createState() => _SalesReportPageNEWState();
// }

// List<SalesMaster> salesList = [];
// double saleTotal = 0;
// final _totalRecordsController = TextEditingController();
// final _totalSalesController = TextEditingController();
// final TextEditingController fromDateController = TextEditingController();
// final TextEditingController toDateController = TextEditingController();
// String st_branchId = '', st_userId = '';
// DateTime fromDate = DateTime.now();
// DateTime toDate = DateTime.now();
// final DateFormat formatter = DateFormat('MM-dd-yyyy');

// void _onDateChanged(BuildContext context) {
//   final fromDateRaw = fromDateController.text.trim();
//   final toDateRaw = toDateController.text.trim();
//   if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
//     String formattedFromDate = DateFormat(
//       'yyyy-MM-dd',
//     ).format(DateFormat('dd-MM-yyyy').parse(fromDateRaw));
//     String formattedToDate = DateFormat(
//       'yyyy-MM-dd',
//     ).format(DateFormat('dd-MM-yyyy').parse(toDateRaw));
//     print('fromDateRaw $fromDateRaw');
//     print('formattedFromDate $formattedFromDate');
//     context.read<SalesReportCubit>().fetchSalesReport(
//       FetchReportRequest(
//         fromDate: formattedFromDate,
//         toDate: formattedToDate,

//         userId: "1",
//         branchId: st_branchId,
//       ),
//     );
//   }
// }

// class _SalesReportPageNEWState extends State<SalesReportPage> {
//   @override
//   void initState() {
//     final now = DateTime.now();
//     fromDateController.text = DateFormat('dd-MM-yyyy').format(now);
//     toDateController.text = DateFormat('dd-MM-yyyy').format(now);
//     DateTime fromDate = DateTime.now();
//     DateTime toDate = DateTime.now();
//     super.initState();
//     fetchSalesReportInitial();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xffF5F6FA),

//         appBar: AppBar(
//           toolbarHeight: 40,
//           backgroundColor: AppColors.theme,
//           title: const Text(
//             'Sales Report',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 await generateAndSharePdf();
//               },
//               icon: Icon(Icons.share),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(0),
//           child: Column(
//             children: [
//               _dateFilter(),
//               // const SizedBox(height: 16),
//               Expanded(
//                 child: BlocConsumer<SalesReportCubit, SlesReportState>(
//                   listener: (context, state) {
//                     if (state is SalesDeleteSuccess) {
//                       Fluttertoast.showToast(
//                         msg: "Sales details deleted successfully..!",
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.black87,
//                         textColor: Colors.white,
//                         fontSize: 14,
//                       );
//                       context.read<SalesReportCubit>().fetchSalesReport(
//                         FetchReportRequest(
//                           fromDate: formatter.format(fromDate),
//                           toDate: formatter.format(toDate),
//                           userId: st_userId,
//                           branchId: st_branchId,
//                         ),
//                       );
//                     }
//                     if (state is SalesDeleteFailure) {
//                       Fluttertoast.showToast(
//                         msg: "Sales details deletion failed..!",
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.black87,
//                         textColor: Colors.white,
//                         fontSize: 14,
//                       );
//                     }
//                     if (state is SalesReportSuccess) {
//                       salesList.clear();
//                       salesList = state.response.salesMaster;
//                       print('salesList ${salesList}');
//                       // _calculateTotals(salesList);
//                     }
//                   },
//                   builder: (context, state) {
//                     if (state is SalesReportLoading ||
//                         state is SlesReportInitial) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (salesList.isEmpty) {
//                       return const Center(child: Text("No data found"));
//                     }
//                     return ListView.builder(
//                       physics: const SoftBounceScrollPhysics(
//                         parent: AlwaysScrollableScrollPhysics(),
//                       ),
//                       itemCount: salesList.length,
//                       itemBuilder: (context, index) {
//                         final sale = salesList[index];
//                         return _salesCard(sale);
//                       },
//                     );
//                   },
//                 ),
//               ),
//               BlocBuilder<SalesReportCubit, SlesReportState>(
//                 builder: (context, state) {
//                   if (state is SalesReportSuccess) {
//                     print('SalesReportSuccess HR');
//                     saleTotal = 0;

//                     for (final item in salesList) {
//                       saleTotal += double.tryParse(item.grandTotal) ?? 0;
//                     }

//                     _totalRecordsController.text = salesList.length.toString();
//                     _totalSalesController.text = saleTotal.toStringAsFixed(2);
//                     return Container(
//                       margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.25),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text(
//                                   "Total Records",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   _totalRecordsController.text,
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           Container(
//                             width: 1,
//                             height: 45,
//                             color: Colors.white24,
//                           ),

//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Text(
//                                   "Total Sales",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white70,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   _totalSalesController.text,
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFFFFE08A),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     Container();
//                   }
//                   return Container();
//                 },
//               ),

//               //  footerTotalSection(_totalRecordsController),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔹 Date Filter
//   Widget _dateFilter() {
//     return Container(
//       color: AppColors.theme,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextFormField(
//                 controller: fromDateController,
//                 readOnly: true,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 decoration: const InputDecoration(
//                   labelText: '  From Date',
//                   labelStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   floatingLabelAlignment: FloatingLabelAlignment.center,
//                   border: InputBorder.none,
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 0,
//                   ),
//                 ),
//                 onTap: () => _selectDate(context, fromDateController),
//               ),
//             ),
//           ),
//           const SizedBox(width: 30),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: TextFormField(
//                   controller: toDateController,
//                   readOnly: true,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   decoration: const InputDecoration(
//                     labelText: 'To Date',
//                     labelStyle: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     floatingLabelAlignment: FloatingLabelAlignment.center,
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 0,
//                     ),
//                   ),
//                   onTap: () => _selectDate(context, toDateController),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(
//     BuildContext context,
//     TextEditingController controller,
//   ) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       final formatted = DateFormat('dd-MM-yyyy').format(picked);
//       controller.text = formatted;
//       // 🔥 FIX: update actual variables
//       if (controller == fromDateController) {
//         fromDate = picked;
//       } else {
//         toDate = picked;
//       }
//       _onDateChanged(context);
//     }
//   }

//   Future<void> generateAndSharePdf() async {
//     final pdf = pw.Document();

//     double totalSales = 0;
//     final logoBytes = await rootBundle.load('assets/images/bw_printlogo.png');

//     final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
//     final companyName = await SharedPreferenceHelper().getCompanyName() ?? '';

//     final companyPhone =
//         await SharedPreferenceHelper().getCompanyPhoneNo() ?? '';

//     final companyLogo = await SharedPreferenceHelper().getCompanyLogo() ?? '';
//     final companyAddress =
//         await SharedPreferenceHelper().getCompanyAddress1() ?? '';
//     final companyAddress2 =
//         await SharedPreferenceHelper().getCompanyAddress2() ?? '';
//     for (final sale in salesList) {
//       totalSales += double.tryParse(sale.grandTotal) ?? 0;
//     }

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(20),

//         build: (context) => [
//           pw.Container(
//             padding: const pw.EdgeInsets.all(16),
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey300),
//               borderRadius: pw.BorderRadius.circular(12),
//             ),
//             child: pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 /// LOGO LEFT
//                 pw.Image(
//                   logoImage,
//                   width: 80,
//                   height: 80,
//                   fit: pw.BoxFit.contain,
//                 ),

//                 pw.SizedBox(width: 15),

//                 /// COMPANY DETAILS CENTER
//                 pw.Expanded(
//                   child: pw.Center(
//                     child: pw.Column(
//                       mainAxisSize: pw.MainAxisSize.min,
//                       crossAxisAlignment: pw.CrossAxisAlignment.center,
//                       children: [
//                         pw.Text(
//                           companyName,
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontSize: 22,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),

//                         pw.SizedBox(height: 4),

//                         pw.Text(
//                           companyAddress,
//                           textAlign: pw.TextAlign.center,
//                           style: const pw.TextStyle(fontSize: 10),
//                         ),

//                         pw.Text(
//                           companyAddress2,
//                           textAlign: pw.TextAlign.center,
//                           style: const pw.TextStyle(fontSize: 10),
//                         ),

//                         pw.Text(
//                           companyPhone,
//                           textAlign: pw.TextAlign.center,
//                           style: const pw.TextStyle(fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 /// BALANCER (optional)
//                 pw.SizedBox(width: 95),
//               ],
//             ),
//           ),

//           /// HEADER
//           // pw.Container(
//           //   padding: const pw.EdgeInsets.all(15),
//           //   decoration: pw.BoxDecoration(
//           //     color: PdfColors.black,
//           //     borderRadius: pw.BorderRadius.circular(10),
//           //   ),
//           //   child: pw.Column(
//           //     crossAxisAlignment: pw.CrossAxisAlignment.start,
//           //     children: [
//           //       pw.Text(
//           //         "SALES REPORT",
//           //         style: pw.TextStyle(
//           //           color: PdfColors.white,
//           //           fontSize: 22,
//           //           fontWeight: pw.FontWeight.bold,
//           //         ),
//           //       ),

//           //       pw.SizedBox(height: 5),

//           //       pw.Text(
//           //         "From : ${fromDateController.text}",
//           //         style: const pw.TextStyle(
//           //           color: PdfColors.white,
//           //           fontSize: 12,
//           //         ),
//           //       ),

//           //       pw.Text(
//           //         "To : ${toDateController.text}",
//           //         style: const pw.TextStyle(
//           //           color: PdfColors.white,
//           //           fontSize: 12,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           pw.SizedBox(height: 10),
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.all(15),
//             decoration: pw.BoxDecoration(
//               color: PdfColors.black,
//               borderRadius: pw.BorderRadius.circular(10),
//             ),
//             child: pw.Column(
//               children: [
//                 pw.Text(
//                   "SALES REPORT",
//                   style: pw.TextStyle(
//                     color: PdfColors.white,
//                     fontSize: 22,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),

//                 pw.SizedBox(height: 8),

//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   children: [
//                     pw.Text(
//                       "From : ${fromDateController.text}",
//                       style: const pw.TextStyle(
//                         color: PdfColors.white,
//                         fontSize: 12,
//                       ),
//                     ),

//                     pw.SizedBox(width: 30),

//                     pw.Text(
//                       "To : ${toDateController.text}",
//                       style: const pw.TextStyle(
//                         color: PdfColors.white,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           pw.SizedBox(height: 10),

//           /// TABLE
//           pw.Table.fromTextArray(
//             border: pw.TableBorder.all(color: PdfColors.grey),
//             headerDecoration: const pw.BoxDecoration(color: PdfColors.black),
//             headerStyle: pw.TextStyle(
//               color: PdfColors.white,
//               fontWeight: pw.FontWeight.bold,
//             ),
//             cellAlignment: pw.Alignment.center,
//             headers: const ["Token", "Invoice", "Date", "Pay Mode", "Amount"],
//             data: salesList.map((sale) {
//               String payMode = '';

//               if ((double.tryParse(sale.cashAmount) ?? 0) > 0) {
//                 payMode = "Cash";
//               } else if ((double.tryParse(sale.cardAmount) ?? 0) > 0) {
//                 payMode = "Card";
//               }

//               return [
//                 sale.billTokenNo.toString(),
//                 sale.invoiceNo.toString(),
//                 DateFormat(
//                   'dd-MM-yyyy',
//                 ).format(DateTime.parse(sale.invoiceDate!)),
//                 payMode,
//                 sale.grandTotal.toString(),
//               ];
//             }).toList(),
//           ),

//           pw.SizedBox(height: 25),
//           pw.Container(
//             width: double.infinity,
//             padding: const pw.EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 12,
//             ),
//             decoration: pw.BoxDecoration(
//               color: PdfColors.black,
//               borderRadius: pw.BorderRadius.circular(8),
//             ),
//             child: pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text(
//                   "TOTAL SALES",
//                   style: pw.TextStyle(
//                     color: PdfColors.white,
//                     fontSize: 16,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.Text(
//                   totalSales.toStringAsFixed(2),
//                   style: pw.TextStyle(
//                     color: PdfColors.white,
//                     fontSize: 16,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // /// TOTAL SALES AT BOTTOM
//           // pw.Align(
//           //   alignment: pw.Alignment.centerRight,
//           //   child: pw.Container(
//           //     padding: const pw.EdgeInsets.symmetric(
//           //       horizontal: 20,
//           //       vertical: 10,
//           //     ),
//           //     decoration: pw.BoxDecoration(
//           //       color: PdfColors.black,
//           //       borderRadius: pw.BorderRadius.circular(8),
//           //     ),
//           //     child: pw.Text(
//           //       "TOTAL SALES : ${totalSales.toStringAsFixed(2)}",
//           //       style: pw.TextStyle(
//           //         color: PdfColors.white,
//           //         fontSize: 16,
//           //         fontWeight: pw.FontWeight.bold,
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );

//     //   final directory = await getTemporaryDirectory();

//     //   final file = File(
//     //     '${directory.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
//     //   );

//     //   await file.writeAsBytes(await pdf.save());

//     //   await Share.shareXFiles([XFile(file.path)], text: 'Sales Report');
//     // }
//     final directory = await getTemporaryDirectory();

//     final fromDate = fromDateController.text.replaceAll('-', '_');
//     final toDate = toDateController.text.replaceAll('-', '_');

//     final file = File(
//       '${directory.path}/Sales_Report_${fromDate}_to_${toDate}.pdf',
//     );

//     await file.writeAsBytes(await pdf.save());

//     await Share.shareXFiles([
//       XFile(file.path),
//     ], text: 'Sales Report ($fromDate to $toDate)');
//   }

//   /// 🔹 Sales Card
//   Widget _salesCard(SalesMaster sale) {
//     String st_PayMode = '';
//     if (double.parse(sale.cashAmount) > 0) {
//       st_PayMode = 'Cash';
//     } else if (double.parse(sale.cardAmount) > 0) {
//       st_PayMode = 'Card';
//     } else if (double.parse(sale.cardAmount) > 0 &&
//         double.parse(sale.cashAmount) > 0) {
//       st_PayMode = 'Multi';
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: InkWell(
//           onTap: () async {
//             String formattedFromDate = '', formattedToDate = '';
//             final fromDateRaw = fromDateController.text.trim();
//             final toDateRaw = toDateController.text.trim();
//             if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
//               String formattedFromDate = DateFormat(
//                 'yyyy-MM-dd',
//               ).format(DateFormat('dd-MM-yyyy').parse(fromDateRaw));
//               String formattedToDate = DateFormat(
//                 'yyyy-MM-dd',
//               ).format(DateFormat('dd-MM-yyyy').parse(toDateRaw));
//             }

//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SalesReportPreviewScreen(
//                   pagefrom: 'SalesReport',
//                   masterId: sale.salesMasterId.toString(),
//                   fromDateFrom: formattedFromDate,
//                   toDateFrom: formattedToDate,
//                 ),
//               ),
//             );

//             context.read<SalesReportCubit>().fetchSalesReport(
//               FetchReportRequest(
//                 fromDate: formatter.format(fromDate),
//                 toDate: formatter.format(toDate),
//                 userId: "1",
//                 branchId: st_branchId,
//               ),
//             );
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   SvgPicture.asset('assets/icons/salesreporticon1.svg'),

//                   // const Icon(Icons.receipt_long, size: 18),
//                   const SizedBox(width: 6),
//                   Text(
//                     "#${sale.billTokenNo}",
//                     style: const TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   SvgPicture.asset('assets/icons/salesreporticon4.svg'),
//                   const SizedBox(width: 6),

//                   Text(
//                     DateFormat(
//                       'dd-MM-yyyy',
//                     ).format(DateTime.parse(sale.invoiceDate!)),
//                   ),

//                   const SizedBox(width: 12),
//                   Visibility(
//                     visible: false,
//                     child: Checkbox(
//                       value: false,
//                       onChanged: (_) {},
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   Visibility(
//                     visible: true,
//                     child: _deleteButton(sale.salesMasterId),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               /// Invoice & Time
//               Row(
//                 children: [
//                   SvgPicture.asset('assets/icons/salesreporticon2.svg'),
//                   SizedBox(width: 6),
//                   Text(sale.invoiceNo.toString()),
//                   SizedBox(width: 68),
//                   Icon(Icons.access_time, size: 16),
//                   SizedBox(width: 6),
//                   Text(formatTime(sale.invoiceTime.toString())),

//                   // Text(sale.invoiceTime.toString()),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               /// Payment & Amount
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       SvgPicture.asset('assets/icons/salesreporticon3.svg'),
//                       SizedBox(width: 6),
//                       Text(st_PayMode.toString()),
//                     ],
//                   ),
//                   Text(
//                     sale.grandTotal.toString(),
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _deleteButton(int salesMasterId) {
//     return InkWell(
//       onTap: () async {
//         final result = await showConfirmationDialog(
//           context,
//           heading: 'Delete Confirmation',
//           message: 'Are you sure you want to delete all selected items?',
//           salesMasterId: salesMasterId,
//         );
//         if (result == true) {
//         } else {}
//       },
//       child: CircleAvatar(
//         radius: 16,
//         backgroundColor: const Color(0xffFFE08A),
//         child: SvgPicture.asset('assets/icons/salesreportdeleteicon.svg'),
//       ),
//     );
//   }

//   void _calculateTotals(List<SalesMaster> list) {
//     saleTotal = 0;

//     for (final item in list) {
//       saleTotal += double.tryParse(item.grandTotal) ?? 0;
//     }

//     _totalRecordsController.text = list.length.toString();
//     _totalSalesController.text = saleTotal.toStringAsFixed(2);
//   }

//   /// 🔹 API / DB CALL
//   Future<void> fetchSalesReport() async {
//     final sharedPrefHelper = SharedPreferenceHelper();
//     st_branchId = await sharedPrefHelper.getBranchId();
//     final expiryDate = await SharedPreferenceHelper().getExpiryDate();
//     print('expiryDate $expiryDate');
//     context.read<SalesReportCubit>().fetchSalesReport(
//       FetchReportRequest(
//         fromDate: formatter.format(fromDate),
//         toDate: formatter.format(toDate),
//         userId: "1",
//         branchId: st_branchId,
//       ),
//     );
//   }

//   Future<void> fetchSalesReportInitial() async {
//     final sharedPrefHelper = SharedPreferenceHelper();
//     st_branchId = await sharedPrefHelper.getBranchId();
//     st_userId = await sharedPrefHelper.getUserId();
//     final expiryDate = await SharedPreferenceHelper().getExpiryDate();
//     print('expiryDate $expiryDate');
//     String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

//     context.read<SalesReportCubit>().fetchSalesReport(
//       FetchReportRequest(
//         fromDate: currentDate,
//         toDate: currentDate,
//         userId: "1", //st_userId
//         branchId: st_branchId,
//       ),
//     );
//   }

//   Future<void> pickDate({required bool isFrom}) async {
//     print('reached SalesReport');
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isFrom ? fromDate : toDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFrom) {
//           fromDate = picked;
//         } else {
//           toDate = picked;
//         }
//       });
//       fetchSalesReport();
//     }
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesreport_result.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/delete_confirmation_dialogue.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/salesreport_widgets.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:share_plus/share_plus.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageNEWState();
}

class _SalesReportPageNEWState extends State<SalesReportPage> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  String stBranchId = '';
  String stUserId = '';

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  final DateFormat displayFormatter = DateFormat('dd-MM-yyyy');
  final DateFormat apiFormatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    fromDate = now;
    toDate = now;

    fromDateController.text = displayFormatter.format(now);
    toDateController.text = displayFormatter.format(now);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSalesReportInitial();
    });
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<void> fetchSalesReportInitial() async {
    final sharedPrefHelper = SharedPreferenceHelper();

    stBranchId = await sharedPrefHelper.getBranchId();
    stUserId = await sharedPrefHelper.getUserId();

    final expiryDate = await SharedPreferenceHelper().getExpiryDate();
    print('expiryDate $expiryDate');

    _fetchSalesReport();
  }

  void _fetchSalesReport() {
    if (!mounted) return;

    context.read<SalesReportCubit>().fetchSalesReport(
      FetchReportRequest(
        fromDate: apiFormatter.format(fromDate),
        toDate: apiFormatter.format(toDate),
        userId: "1",
        branchId: stBranchId,
      ),
    );
  }

  void _onDateChanged() {
    if (fromDateController.text.trim().isEmpty ||
        toDateController.text.trim().isEmpty) {
      return;
    }

    _fetchSalesReport();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF5F6FA),
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: AppColors.theme,
          title: const Text(
            'Sales Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await generateAndSharePdf();
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              _dateFilter(),
              Expanded(
                child: BlocConsumer<SalesReportCubit, SlesReportState>(
                  listener: (context, state) {
                    if (state is SalesDeleteSuccess) {
                      Fluttertoast.showToast(
                        msg: "Sales details deleted successfully..!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black87,
                        textColor: Colors.white,
                        fontSize: 14,
                      );

                      _fetchSalesReport();
                    }

                    if (state is SalesDeleteFailure) {
                      Fluttertoast.showToast(
                        msg: "Sales details deletion failed..!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black87,
                        textColor: Colors.white,
                        fontSize: 14,
                      );
                    }

                    if (state is SalesReportError) {
                      Fluttertoast.showToast(
                        msg: state.error,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black87,
                        textColor: Colors.white,
                        fontSize: 14,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SalesReportLoading ||
                        state is SlesReportInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SalesReportError) {
                      return Center(child: Text(state.error));
                    }

                    if (state is SalesReportSuccess) {
                      final List<SalesMaster> salesList =
                          state.response.salesMaster;

                      if (salesList.isEmpty) {
                        return const Center(child: Text("No data found"));
                      }

                      return ListView.builder(
                        physics: const SoftBounceScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: salesList.length,
                        itemBuilder: (context, index) {
                          final sale = salesList[index];
                          return _salesCard(sale);
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              BlocBuilder<SalesReportCubit, SlesReportState>(
                builder: (context, state) {
                  if (state is SalesReportSuccess) {
                    final List<SalesMaster> salesList =
                        state.response.salesMaster;

                    if (salesList.isEmpty) {
                      return const SizedBox();
                    }

                    double saleTotal = 0;

                    for (final item in salesList) {
                      saleTotal += double.tryParse(item.grandTotal) ?? 0;
                    }

                    return _bottomTotalSection(
                      totalRecords: salesList.length.toString(),
                      totalSales: saleTotal.toStringAsFixed(2),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateFilter() {
    return Container(
      color: AppColors.theme,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: fromDateController,
                readOnly: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  labelText: '  From Date',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 0,
                  ),
                ),
                onTap: () => _selectDate(context, fromDateController),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  controller: toDateController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'To Date',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 0,
                    ),
                  ),
                  onTap: () => _selectDate(context, toDateController),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime initialDate = DateTime.now();

    if (controller == fromDateController) {
      initialDate = fromDate;
    } else {
      initialDate = toDate;
    }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted = displayFormatter.format(picked);

      setState(() {
        controller.text = formatted;

        if (controller == fromDateController) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });

      _onDateChanged();
    }
  }

  Future<void> generateAndSharePdf() async {
    final currentState = context.read<SalesReportCubit>().state;

    if (currentState is! SalesReportSuccess) {
      Fluttertoast.showToast(
        msg: "No report data available to share.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
      return;
    }

    final List<SalesMaster> salesList = currentState.response.salesMaster;

    if (salesList.isEmpty) {
      Fluttertoast.showToast(
        msg: "No report data available to share.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14,
      );
      return;
    }

    final pdf = pw.Document();

    double totalSales = 0;

    final logoBytes = await rootBundle.load('assets/images/bw_printlogo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final companyName = await SharedPreferenceHelper().getCompanyName() ?? '';
    final companyPhone =
        await SharedPreferenceHelper().getCompanyPhoneNo() ?? '';
    final companyAddress =
        await SharedPreferenceHelper().getCompanyAddress1() ?? '';
    final companyAddress2 =
        await SharedPreferenceHelper().getCompanyAddress2() ?? '';

    for (final sale in salesList) {
      totalSales += double.tryParse(sale.grandTotal) ?? 0;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(
                  logoImage,
                  width: 80,
                  height: 80,
                  fit: pw.BoxFit.contain,
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          companyName,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          companyAddress,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          companyAddress2,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          companyPhone,
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 95),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              color: PdfColors.black,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  "SALES REPORT",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      "From : ${fromDateController.text}",
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(width: 30),
                    pw.Text(
                      "To : ${toDateController.text}",
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.black),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
            ),
            cellAlignment: pw.Alignment.center,
            headers: const ["Token", "Invoice", "Date", "Pay Mode", "Amount"],
            data: salesList.map((sale) {
              return [
                sale.billTokenNo.toString(),
                sale.invoiceNo.toString(),
                DateFormat(
                  'dd-MM-yyyy',
                ).format(DateTime.parse(sale.invoiceDate!)),
                _getPayMode(sale),
                sale.grandTotal.toString(),
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 25),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: pw.BoxDecoration(
              color: PdfColors.black,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "TOTAL SALES",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  totalSales.toStringAsFixed(2),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final directory = await getTemporaryDirectory();

    final pdfFromDate = fromDateController.text.replaceAll('-', '_');
    final pdfToDate = toDateController.text.replaceAll('-', '_');

    final file = File(
      '${directory.path}/Sales_Report_${pdfFromDate}_to_$pdfToDate.pdf',
    );

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Sales Report ($pdfFromDate to $pdfToDate)');
  }

  Widget _salesCard(SalesMaster sale) {
    final String stPayMode = _getPayMode(sale);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            String formattedFromDate = '';
            String formattedToDate = '';

            final fromDateRaw = fromDateController.text.trim();
            final toDateRaw = toDateController.text.trim();

            if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
              formattedFromDate = apiFormatter.format(
                displayFormatter.parse(fromDateRaw),
              );

              formattedToDate = apiFormatter.format(
                displayFormatter.parse(toDateRaw),
              );
            }

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesReportPreviewScreen(
                  pagefrom: 'SalesReport',
                  masterId: sale.salesMasterId.toString(),
                  fromDateFrom: formattedFromDate,
                  toDateFrom: formattedToDate,
                ),
              ),
            );

            if (!mounted) return;

            _fetchSalesReport();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/salesreporticon1.svg'),
                  const SizedBox(width: 6),
                  Text(
                    "#${sale.billTokenNo}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/salesreporticon4.svg'),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(sale.invoiceDate!)),
                  ),
                  const SizedBox(width: 12),
                  Visibility(
                    visible: false,
                    child: Checkbox(
                      value: false,
                      onChanged: (_) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: true,
                    child: _deleteButton(sale.salesMasterId),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/salesreporticon2.svg'),
                  const SizedBox(width: 6),
                  Text(sale.invoiceNo.toString()),
                  const SizedBox(width: 68),
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 6),
                  Text(formatTime(sale.invoiceTime.toString())),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/salesreporticon3.svg'),
                      const SizedBox(width: 6),
                      Text(stPayMode),
                    ],
                  ),
                  Text(
                    sale.grandTotal.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPayMode(SalesMaster sale) {
    final double cashAmount = double.tryParse(sale.cashAmount) ?? 0;
    final double cardAmount = double.tryParse(sale.cardAmount) ?? 0;

    if (cashAmount > 0 && cardAmount > 0) {
      return 'Multi';
    } else if (cashAmount > 0) {
      return 'Cash';
    } else if (cardAmount > 0) {
      return 'Card';
    }

    return '';
  }

  Widget _deleteButton(int salesMasterId) {
    return InkWell(
      onTap: () async {
        final result = await showConfirmationDialog(
          context,
          heading: 'Delete Confirmation',
          message: 'Are you sure you want to delete all selected items?',
          salesMasterId: salesMasterId,
        );

        if (result == true) {
          // Refresh happens from SalesDeleteSuccess listener.
        }
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xffFFE08A),
        child: SvgPicture.asset('assets/icons/salesreportdeleteicon.svg'),
      ),
    );
  }

  Widget _bottomTotalSection({
    required String totalRecords,
    required String totalSales,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Total Records",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalRecords,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 45, color: Colors.white24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Total Sales",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalSales,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFE08A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          fromDateController.text = displayFormatter.format(picked);
        } else {
          toDate = picked;
          toDateController.text = displayFormatter.format(picked);
        }
      });

      _fetchSalesReport();
    }
  }
}
