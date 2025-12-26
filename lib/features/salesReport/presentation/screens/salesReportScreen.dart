// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
// import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
// import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
// import 'package:quikservnew/services/shared_preference_helper.dart';
//
//
// class SalesReportScreen extends StatefulWidget {
//   const SalesReportScreen({super.key});
//
//   @override
//   State<SalesReportScreen> createState() => _SalesReportScreenState();
// }
//
// List<SalesReportMasterByDateResult> saleList = [];
// List<SalesDetailsResult> salesDetailsList = [];
// List<Suppliers> suppliersList = [];
// String st_branchId = '',
//     st_userId = '',
//     st_fromDatePref = '',
//     st_toDatePref = '',
//     st_DbName = '',
//     st_selectedSupplier = 'All',
//     st_selectedSupplierId = '0';
//
// DateTime? _selectedDate;
// int clickFlag = 0;
//
// class _SalesReportScreenState extends State<SalesReportScreen> {
//   final _searchController = TextEditingController();
//   final _searchTypeController = TextEditingController();
//   final _fromDateController = TextEditingController();
//   final _toDateController = TextEditingController();
//   final _fromDateFormattedController = TextEditingController();
//   final _toDateFormattedController = TextEditingController();
//   final _totalRecordsController = TextEditingController();
//   final _totalSalesController = TextEditingController();
//   double saleTotal = 0;
//   double saleItemTotal = 0;
//
//   @override
//   initState() {
//
//     fetchReportDetails();
//
//     _searchController.text = '';
//     _searchTypeController.text = 'Customer';
//     _searchController.addListener(_textListener);
//     _fromDateController.addListener(_textListener);
//     _toDateController.addListener(_textListener);
//
//     super.initState();
//   }
//
//   void _textListener() {
//     print(_searchController.text);
//     if (_searchController.text.isEmpty) {
//       //_searchTypeController.text = 'Customer';
//       //context.read<SaleHistoryCubit>().fetchAllSales();
//     }
//     if (_fromDateController.text.isNotEmpty &&
//         _toDateController.text.isNotEmpty) {
//       //   if (clickFlag == 1) {
//       print('clickFlag $clickFlag');
//       print(_fromDateFormattedController.text.toString());
//       String st_fromDate = _fromDateFormattedController.text.toString();
//       String st_toDate = _toDateFormattedController.text.toString();
//       print('st_fromDate $st_fromDate');
//       print('st_toDate $st_toDate');
//
//       context.read<SlesReportCubit>().fetchSalesReport(
//           FetchReportRequest(
//               from_date: st_fromDate,
//               to_date: st_toDate,
//               user_id: st_selectedSupplierId, branchId: st_branchId));
//     }
//   }
//
//   void _resetTotals() {
//     setState(() {
//       _totalRecordsController.text = '0';
//       _totalSalesController.text = '0.00';
//       saleTotal = 0;
//       saleItemTotal = 0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidthactual = MediaQuery.of(context).size.width;
//     double screenWidth = MediaQuery.of(context).size.width - 16;
//    // ProgressDialog pr = ProgressDialog(context);
//     return PopScope(
//       canPop: true, //When false, blocks the current route from being popped.
//       onPopInvoked: (didPop) {
//         //do your logic here:
//        // context.read<AppbarCubit>().homeScreenPageSelected();
//         // context.read<HomeCubit>().fetchDashboardSalesDetails();
//       },
//       child: Scaffold(
//           backgroundColor: Colors.grey.shade200,
//
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () => _showUserPicker(context), // custom method
//                     child: Container(
//                       height: 50,
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         //border: Border.all(color: Colors.grey.shade400),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             st_selectedSupplier,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.black87),
//                           ),
//                           const Icon(Icons.arrow_drop_down),
//                           // indi cates bottom sheet opens upward
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 70,
//                   color: Colors.blue,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: Container(
//                             //color: Colors.white,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               // Background color
//                               borderRadius: BorderRadius.circular(8),
//                               // Rounded corners
//                               // border: Border.all(
//                               //   color: Colors.black, // Border color
//                               //   width: 1, // Border width
//                               // ),
//                             ),
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: TextFormField(
//                                   readOnly: true,
//                                   controller: _fromDateController,
//                                   onTap: () {
//                                     clickFlag = 1;
//                                     _selectDate(context, 'From');
//                                   },
//                                   decoration: const InputDecoration(
//                                     hintText: 'From Date ',
//                                     labelText: 'From Date',
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Container(
//                               //color: Colors.white,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 // Background color
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: TextFormField(
//                                     readOnly: true,
//                                     controller: _toDateController,
//                                     onTap: () {
//                                       _selectDate(context, 'To');
//                                     },
//                                     decoration: const InputDecoration(
//                                       hintText: 'To Date ',
//                                       labelText: 'To Date',
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 BlocConsumer<SaleCubit, SaleState>(
//                   listener: (context, state) {
//                     // if (state is SuppliersFetchSuccess) {
//                     //   suppliersList.clear();
//                     //   Suppliers sl = new Suppliers(
//                     //       id: "0",
//                     //       userType: "",
//                     //       username: "",
//                     //       password: "",
//                     //       isactive: "",
//                     //       name: "All");
//                     //   suppliersList.add(sl);
//                     //   suppliersList.addAll(state.result.details);
//                     // }
//                   },
//                   builder: (context, state) {
//                     return Padding(
//                       padding: const EdgeInsets.only(
//                           left: 8.0, right: 8.0, bottom: 8.0, top: 4.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 4.0, right: 4.0),
//                               child: Container(
//                                 //  height: 50,
//                                 //color: Colors.white,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   // Background color
//                                   borderRadius: BorderRadius.circular(8),
//                                   // Rounded corners
//                                   // border: Border.all(
//                                   //   color: Colors.black, // Border color
//                                   //   width: 1, // Border width
//                                   // ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         // Makes the column fit its children
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(4.0),
//                                             child: Text(
//                                               double.tryParse(
//                                                           _totalSalesController
//                                                               .text)
//                                                       ?.toStringAsFixed(
//                                                           get_decimalpoints()) ??
//                                                   '0.00',
//                                               // _totalSalesController.text
//                                               //     .toString(),
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: Text(
//                                               'Total Sales',
//                                               style: TextStyle(
//                                                   fontSize: 13,
//                                                   color: Colors.green,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 8.0, bottom: 2.0),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         // Makes the column fit its children
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.all(4.0),
//                                             child: Text(
//                                               _totalRecordsController.text
//                                                   .toString(),
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.all(4.0),
//                                             child: Text(
//                                               'Total Records',
//                                               style: TextStyle(
//                                                   fontSize: 13,
//                                                   color: Colors.red,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height - 200,
//                         width: screenWidth,
//                         child: BlocConsumer<SlesReportCubit, SlesReportState>(
//                           // Only report states to prevent spinner flicker
//                           listenWhen: (prev, curr) =>
//                               curr is SlesReportInitial ||
//                               curr is SalesReportSuccess,
//                           buildWhen: (prev, curr) =>
//                               curr is SlesReportInitial ||
//                               curr is SalesReportSuccess,
//                           listener: (context, state) {
//                             //  saleList.clear();
//                             //print('Length of array $saleList.length');
//                             if (state is SlesReportInitial) {
//                               _resetTotals();
//                             }
//                             if (state is SalesReportSuccess) {
//                               // pr.hide();
//                               saleList.clear();
//                               saleList.add(state.list);
//                             }
//                             _totalRecordsController.text =
//                                 saleList.first.salesMaster.length.toString();
//                             saleTotal = 0;
//                             saleItemTotal = 0;
//                             for (int i = 0;
//                                 i < saleList.first.salesMaster.length;
//                                 i++) {
//                               try {
//                                 saleItemTotal = double.parse(
//                                     saleList.first.salesMaster[i].grandTotal);
//                               } catch (_) {}
//                               saleTotal = saleTotal + saleItemTotal;
//                             }
//                             _totalSalesController.text = saleTotal.toString();
//                             print(saleList.length);
//                           },
//                           builder: (context, saleState) {
//                             // Loading current report call
//                             if (saleState is SlesReportInitial) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             }
//
//                             // Success — build list inline here
//                             if (saleState is SalesReportSuccess) {
//                               final masters = saleState.list.salesMaster;
//                               if (masters.isEmpty) {
//                                 return const Center(
//                                     child: Text(
//                                         'No sales found for the selected filters.'));
//                               }
//                             }
//                             if (saleList.length > 0) {
//                               print('length ${saleList.length}');
//                               //  if (saleList[0].salesmasters.length > 0) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 10.0),
//                                 child: ListView.separated(
//                                   itemCount: saleList.first.salesMaster.length,
//                                   separatorBuilder:
//                                       (BuildContext context, int index) =>
//                                           Container(
//                                     height: 5,
//                                   ),
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     int slno = index + 1;
//                                     bool custSecondStatus = false;
//                                     String st_custName1 = '', st_custName2 = '';
//                                     String st_custName = saleList
//                                         .first.salesMaster[index].ledgerName
//                                         .toString();
//                                     st_custName1 = st_custName;
//                                     if (st_custName.length > 38) {
//                                       st_custName1 =
//                                           st_custName.substring(0, 38);
//                                       if (st_custName.length > 76) {
//                                         st_custName2 =
//                                             st_custName.substring(38, 76);
//                                       } else {
//                                         st_custName2 = st_custName.substring(
//                                             38, st_custName.length);
//                                       }
//                                     }
//                                     if (st_custName2.length > 1) {
//                                       custSecondStatus = true;
//                                     }
//                                     return InkWell(
//                                       onTap: () {
//                                         String st_fromDate =
//                                             _fromDateController.text.toString();
//                                         String st_toDate =
//                                             _toDateController.text.toString();
//                                         _fromDateController.text = '';
//                                         _toDateController.text = '';
//
//                                         clickFlag = 0;
//
//                                         // context
//                                         //     .read<SaleCubit>()
//                                         //     .fetchReportSalesDetailsByMasterId(
//                                         //         MasterIdRequest(
//                                         //             db_name: st_DbName,
//                                         //             masterId: saleList[0]
//                                         //                 .salesMaster[index]
//                                         //                 .salesMasterId));
//
//                                         context
//                                             .read<AppbarCubit>()
//                                             .salesReportViewSelected();
//                                         Navigator.push(
//                                           context,
//                                           PageRouteBuilder(
//                                             pageBuilder: (context, animation,
//                                                     secondaryAnimation) =>
//                                                 SaleReportPreviewScreen(
//                                               st_fromDate:
//                                                   _fromDateFormattedController
//                                                       .text
//                                                       .toString(),
//                                               st_toDate:
//                                                   _toDateFormattedController
//                                                       .text
//                                                       .toString(),
//                                               pagefrom: 'SalesReport',
//                                               masterId: saleList[0]
//                                                   .salesMaster[index]
//                                                   .salesMasterId,
//                                             ),
//                                             transitionsBuilder: (context,
//                                                 animation,
//                                                 secondaryAnimation,
//                                                 child) {
//                                               const begin = Offset(1.0, 0.0);
//                                               const end = Offset.zero;
//                                               const curve = Curves.ease;
//
//                                               var tween = Tween(
//                                                       begin: begin, end: end)
//                                                   .chain(
//                                                       CurveTween(curve: curve));
//
//                                               return SlideTransition(
//                                                 position:
//                                                     animation.drive(tween),
//                                                 child: child,
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       child: Card(
//                                         color: Colors.white,
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(8),
//                                           ),
//                                         ),
//                                         child: Column(
//                                           //  mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                   color: appThemeLightOrange,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   8),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   8))),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 8.0, right: 10),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       '#${saleList[0].salesMaster[index].invoiceNo.toString()}',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 15,
//                                                           color: darkGreen),
//                                                     ),
//                                                     Text(
//                                                       DateFormat('dd-MM-yyyy')
//                                                           .format(
//                                                         DateTime.parse(saleList[
//                                                                 0]
//                                                             .salesMaster[index]
//                                                             .invoiceDate
//                                                             .toString()),
//                                                       ),
//                                                       style: TextStyle(
//                                                           fontSize: 15,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           color: darkGreen),
//                                                     ),
//                                                     // Text(
//                                                     //   saleList[
//                                                     //           0]
//                                                     //       .salesMaster[
//                                                     //           index]
//                                                     //       .invoiceNo
//                                                     //       .toString(),
//                                                     //   style:  TextStyle(
//                                                     //       fontWeight: FontWeight
//                                                     //           .bold,
//                                                     //       fontSize:
//                                                     //           15,color:darkGreen),
//                                                     // ),
//
//                                                     // SizedBox(width: 280,),
//                                                     IconButton(
//                                                       onPressed: () {
//                                                         showDialog(
//                                                           context: context,
//                                                           builder: (context) =>
//                                                               AlertDialog(
//                                                             title: Text(
//                                                                 'Confirm Delete'),
//                                                             content: Text(
//                                                                 'Are you sure you want to delete this sale?'),
//                                                             actions: [
//                                                               TextButton(
//                                                                 onPressed: () =>
//                                                                     Navigator.pop(
//                                                                         context), // Just close
//                                                                 child: Text(
//                                                                     'Cancel'),
//                                                               ),
//                                                               TextButton(
//                                                                 onPressed:
//                                                                     () async {
//                                                                   final dbName =
//                                                                       AppData
//                                                                           .dbName;
//                                                                   final salesMasterId = saleList[
//                                                                           0]
//                                                                       .salesMaster[
//                                                                           index]
//                                                                       .salesMasterId;
//
//                                                                   final deleteRequest =
//                                                                       SalesDeleteRequest(
//                                                                     db_name:
//                                                                         dbName!,
//                                                                     unit_id:
//                                                                         salesMasterId
//                                                                             .toString(),
//                                                                   );
//
//                                                                   context
//                                                                       .read<
//                                                                           SaleCubit>()
//                                                                       .deleteSalesFromServer(
//                                                                           deleteRequest);
//
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                   final fromDate =
//                                                                       _fromDateFormattedController
//                                                                           .text
//                                                                           .trim();
//                                                                   final toDate =
//                                                                       _toDateFormattedController
//                                                                           .text
//                                                                           .trim();
//
//                                                                   final request =
//                                                                       SaleReportMasterByDateParameter(
//                                                                     db_name:
//                                                                         dbName,
//                                                                     FromDate:
//                                                                         fromDate,
//                                                                     ToDate:
//                                                                         toDate,
//                                                                     userId: '1',
//                                                                   );
//
//                                                                   await context
//                                                                       .read<
//                                                                           SaleCubit>()
//                                                                       .salesReportMasterByDate(
//                                                                           request);
//                                                                   //  Navigator.pop(context);
//                                                                 },
//                                                                 child: Text(
//                                                                     'Delete',
//                                                                     style: TextStyle(
//                                                                         color: Colors
//                                                                             .red)),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         );
//                                                       },
//                                                       icon: Icon(Icons.delete),
//                                                       color: Colors.red,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     // 👇 Add this print to see if value exists
//                                                     Builder(builder: (_) {
//                                                       print(
//                                                           "st_custName1: $st_custName1");
//                                                       return const SizedBox
//                                                           .shrink(); // return a dummy widget inside builder
//                                                     }),
//                                                     Text(
//                                                       st_custName1.toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 11),
//                                                     ),
//                                                     Visibility(
//                                                       // replacement: SizedBox.shrink(),
//                                                       visible: custSecondStatus,
//                                                       child: Text(
//                                                         st_custName2.toString(),
//                                                         textAlign:
//                                                             TextAlign.start,
//                                                         style: const TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 11),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 8.0, right: 8),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             0.0),
//                                                     child: Column(
//                                                       children: [
//                                                         const Text(
//                                                           'Sub',
//                                                           style: TextStyle(
//                                                               fontSize: 13),
//                                                         ),
//                                                         Text(
//                                                           saleList[0]
//                                                               .salesMaster[
//                                                                   index]
//                                                               .subTotal
//                                                               .toString(),
//                                                           style: const TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             0.0),
//                                                     child: Column(
//                                                       children: [
//                                                         const Text(
//                                                           'Vat',
//                                                           style: TextStyle(
//                                                               fontSize: 13),
//                                                         ),
//                                                         Text(
//                                                           saleList[0]
//                                                               .salesMaster[
//                                                                   index]
//                                                               .vatAmount
//                                                               .toString(),
//                                                           style: const TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         children: [
//                                                           const Text(
//                                                             'Total',
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                             saleList[0]
//                                                                 .salesMaster[
//                                                                     index]
//                                                                 .grandTotal
//                                                                 .toString(),
//                                                             style: const TextStyle(
//                                                                 fontSize: 13,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ],
//                                                       )
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                               // }
//                             } else {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                             // return Container();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
//
//   void _handleSubmitted(BuildContext context, String value) {
//     // Handle what to do when the user submits the text
//     print('Submitted: $value');
//     // if(_searchTypeController.text=='Customer'){
//     //   context
//     //       .read<SaleHistoryCubit>()
//     //       .fetchSalesByCustomer(Customerparameter(customerName: value));
//     // }
//     // if(_searchTypeController.text=='InvoiceNo'){
//     //   context
//     //       .read<SaleHistoryCubit>()
//     //       .fetchSalesByInvoiceNo(Invoicenoparameter(invoiceNo: value.toString()));
//     // }
//     // if(_searchTypeController.text=='Date'){
//     //   context
//     //       .read<SaleHistoryCubit>()
//     //       .fetchSalesByDate(Dateparameter(createdAt: value));
//     // }
//     // else{
//     //   context
//     //       .read<SaleHistoryCubit>()
//     //       .fetchSalesByCustomer(Customerparameter(customerName: value));
//     // }
//   }
//
//   Future<void> _selectDate(BuildContext context, String stDateType) async {
//     _resetTotals();
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(), // default date
//       firstDate: DateTime(2000), // earliest date
//       lastDate: DateTime.now(), // latest date
//     );
//
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       if (stDateType == 'From') {
//         _fromDateFormattedController.text =
//             _formatDateYMD(pickedDate.toString());
//         _fromDateController.text = _formatDate(pickedDate.toString());
//       } else {
//         _toDateFormattedController.text = _formatDateYMD(pickedDate.toString());
//         _toDateController.text = _formatDate(pickedDate.toString());
//       }
//     }
//     setState(() {
//       saleList = [];
//     });
//
//     context.read<SaleCubit>().salesReportMasterByDate(
//           SaleReportMasterByDateParameter(
//             db_name: st_DbName,
//             FromDate: _fromDateFormattedController.text,
//             ToDate: _toDateFormattedController.text,
//             userId: "0",
//           ),
//         );
//   }
//
//   Future<void> fetchReportDetails() async {
//     st_branchId = await SharedPreferenceHelper().getBranchId() ?? "";
//
//
//     _fromDateFormattedController.text = _formatDateYMD(getDateTime());
//     _toDateFormattedController.text = _formatDateYMD(getDateTime());
//     _fromDateController.text = _formatDate(getDateTime().toString());
//     _toDateController.text = _formatDate(getDateTime().toString());
//
//     //String st_currentDateFormatted = _formatDateYMD(getDateTime());
//     // context.read<ReportCubit>().fetchSalesMaster(SalesMasterRequestBody(
//     //     fromDate: _fromDateFormattedController.text.toString(),
//     //     toDate: _toDateFormattedController.text.toString(),
//     //     userId: st_userId,
//     //     branchId: st_branchId));
//     context.read<SaleCubit>().fetchSuppliers(SuppliersOrCashierRequest(
//         db_name: st_DbName, userId: st_selectedSupplierId));
//     String st_fromDate = _fromDateFormattedController.text.toString();
//     String st_toDate = _toDateFormattedController.text.toString();
//     context
//         .read<SaleCubit>()
//         .fetchAllSalesDetails(CommonParameter(db_name: st_DbName));
//
//     print('st_fromDateHere $st_fromDate');
//     print('st_toDate $st_toDate');
//     print(_fromDateFormattedController.text.toString());
//     if (clickFlag == 0 && st_fromDatePref.length > 5) {
//       _fromDateController.text = st_fromDatePref;
//       _toDateController.text = st_toDatePref;
//       // Parse the string into a DateTime object
//       DateFormat inputFormat = DateFormat("dd-MM-yyyy");
//       DateTime dateTimeFrom = inputFormat.parse(st_fromDatePref);
//       DateTime dateTimeTo = inputFormat.parse(st_toDatePref);
//
//       // Format the DateTime object into yyyy-MM-dd format
//       DateFormat outputFormat = DateFormat("yyyy-MM-dd");
//       String formattedFromDate = outputFormat.format(dateTimeFrom);
//       String formattedToDate = outputFormat.format(dateTimeTo);
//       st_fromDate = formattedFromDate.toString();
//       st_toDate = formattedToDate.toString();
//       print('st_toDatePref $st_toDate');
//     }
//   }
//
//   void _showUserPicker(BuildContext context) {
//     showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext ctx) {
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: suppliersList.length,
//           itemBuilder: (ctx, index) {
//             return ListTile(
//               title: Text(suppliersList[index].name),
//               onTap: () {
//                 setState(() {
//                   st_selectedSupplierId = suppliersList[index].id;
//                   st_selectedSupplier = suppliersList[index].name;
//                 });
//                 String st_fromDate =
//                     _fromDateFormattedController.text.toString();
//                 String st_toDate = _toDateFormattedController.text.toString();
//                 context.read<SaleCubit>().salesReportMasterByDate(
//                     SaleReportMasterByDateParameter(
//                         db_name: st_DbName,
//                         FromDate: st_fromDate,
//                         ToDate: st_toDate,
//                         userId: st_selectedSupplierId));
//                 Navigator.pop(context);
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// String _formatDate(String dateStr) {
//   DateTime dateTime =
//       DateTime.parse(dateStr); // Parse the string into a DateTime object
//   String formattedDate =
//       DateFormat('dd-MM-yyyy').format(dateTime); // Format the DateTime object
//   return formattedDate;
// }
//
// String _formatDateYMD(String dateStr) {
//   DateTime dateTime =
//       DateTime.parse(dateStr); // Parse the string into a DateTime object
//   String formattedDate =
//       DateFormat('yyyy-MM-dd').format(dateTime); // Format the DateTime object
//   return formattedDate;
// }
// // This function will open the date picker dialog
