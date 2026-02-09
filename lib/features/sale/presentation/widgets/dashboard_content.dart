import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/screens/dailyCloseReportScreen.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/screens/itemwise_report_screen.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesReportScreen.dart';

// ✅ add this (same used in HomeScreen)
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';

final DateFormat formatter = DateFormat('dd MMM yyyy');

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(
    DateTime.now(),
  );
  final ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });

    fromDateNotifier.addListener(_fetchReport);
    toDateNotifier.addListener(_fetchReport);
  }

  @override
  void dispose() {
    fromDateNotifier.removeListener(_fetchReport);
    toDateNotifier.removeListener(_fetchReport);
    fromDateNotifier.dispose();
    toDateNotifier.dispose();
    super.dispose();
  }

  double _toDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  void _fetchReport() {
    final fromDate = DateFormat('yyyy-MM-dd').format(fromDateNotifier.value);
    final toDate = DateFormat('yyyy-MM-dd').format(toDateNotifier.value);

    context.read<SalesReportCubit>().fetchSalesReportMasterByDate(
      SalesReportMasterByDateRequest(fromDate: fromDate, toDate: toDate),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    ValueNotifier<DateTime> notifier,
  ) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: notifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      notifier.value = selected;

      if (fromDateNotifier.value.isAfter(toDateNotifier.value)) {
        toDateNotifier.value = fromDateNotifier.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐⭐⭐ KEY FIX: Set status bar BEFORE anything else
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: AppColors.theme,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    });
    return ScrollConfiguration(
      behavior: const AppScrollBehavior(), // ✅ no glow + consistent behavior
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: AppColors.theme,
          title: const Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            // ✅ Soft/reduced bounce
            physics: const SoftBounceScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// DATE PICKERS
                  Row(
                    children: [
                      DateCard(
                        title: 'From Date',
                        dateNotifier: fromDateNotifier,
                        onTap: () => _pickDate(context, fromDateNotifier),
                      ),
                      const SizedBox(width: 12),
                      DateCard(
                        title: 'To Date',
                        dateNotifier: toDateNotifier,
                        onTap: () => _pickDate(context, toDateNotifier),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// SALES STATS
                  BlocBuilder<SalesReportCubit, SlesReportState>(
                    builder: (context, state) {
                      bool isLoading = true;
                      String totalCountText = '--';
                      String totalAmountText = '--';
                      // if (state is SalesReportMasterByDateSuccess) {
                      //   final list = state.response.salesMaster;

                      //   final totalCount = list.length;
                      //   final totalAmount = list.fold<double>(
                      //     0.0,
                      //     (sum, item) => sum + _toDouble(item.grandTotal),
                      //   );
                      if (state is SalesReportMasterByDateSuccess) {
                        final list = state.response.salesMaster;
                        totalCountText = list.length.toString();

                        final totalAmount = list.fold<double>(
                          0.0,
                          (sum, item) => sum + _toDouble(item.grandTotal),
                        );
                        totalAmountText = totalAmount.toStringAsFixed(2);

                        isLoading = false;
                      } else if (state is SalesReportMasterByDateError) {
                        isLoading = false;
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Total Sales Count',
                              value: totalCountText,
                              isLoading: isLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              title: 'Total Sales Amount',
                              value: totalAmountText,
                              isLoading: isLoading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //     if (state is SalesReportMasterByDateError) {
                  //       return const Text('Failed to load sales data');
                  //     }

                  //     return const Center(child: CircularProgressIndicator());
                  //   },
                  // ),
                  const SizedBox(height: 14),

                  /// CASH BALANCE
                  BlocBuilder<SalesReportCubit, SlesReportState>(
                    builder: (context, state) {
                      bool isLoading = true;
                      String cashText = '--';
                      // if (state is SalesReportMasterByDateSuccess) {
                      //   final list = state.response.salesMaster;

                      //   final cashBalance = list.fold<double>(
                      //     0.0,
                      //     (sum, item) => sum + _toDouble(item.cashAmount),
                      //   );
                      if (state is SalesReportMasterByDateSuccess) {
                        final list = state.response.salesMaster;

                        final cashBalance = list.fold<double>(
                          0.0,
                          (sum, item) => sum + _toDouble(item.cashAmount),
                        );
                        cashText = cashBalance.toStringAsFixed(2);

                        isLoading = false;
                      } else if (state is SalesReportMasterByDateError) {
                        isLoading = false;
                      }
                      return Container(
                        height: 100,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6E0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Cash Balance',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ✅ ONLY VALUE LOADING
                            if (isLoading)
                              const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              Text(
                                cashText,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // TRANSACTION
                  const Text(
                    'Transaction',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          onTap: () {},
                          icon: Icons.receipt_long_outlined,
                          label: 'Sales Invoice',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.camera_alt_outlined,
                          label: 'Payment',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // REPORTS
                  const Text(
                    'Reports',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.receipt_outlined,
                          label: 'Sales Report',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SalesReportPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.flag_outlined,
                          label: 'Item Report',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemWiseReportScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.calendar_month_outlined,
                          label: 'Daily Closing\nReport',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DailyClosingReportScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
                  ),

                  const SizedBox(height: 24), // ✅ some bottom space
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isLoading;
  const _StatCard({
    required this.title,
    required this.value,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          // ✅ ONLY VALUE LOADING
          if (isLoading)
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// DATE CARD
class DateCard extends StatelessWidget {
  final String title;
  final ValueNotifier<DateTime> dateNotifier;
  final VoidCallback onTap;

  const DateCard({
    super.key,
    required this.title,
    required this.dateNotifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                ValueListenableBuilder<DateTime>(
                  valueListenable: dateNotifier,
                  builder: (_, date, __) {
                    return Text(
                      formatter.format(date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
