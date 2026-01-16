import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesReportScreen.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/sales_report_screen.dart';

final DateFormat formatter = DateFormat('dd MMM yyyy');

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  // ValueNotifiers (can be moved to controller later)
  final ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(
    DateTime.now(),
  );
  final ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());
  @override
  void initState() {
    super.initState();

    /// Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });

    /// Fetch again when date changes
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

  /// Convert any dynamic/Object to double safely
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

      /// Ensure fromDate <= toDate
      if (fromDateNotifier.value.isAfter(toDateNotifier.value)) {
        toDateNotifier.value = fromDateNotifier.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.theme,
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
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
                  if (state is SalesReportMasterByDateSuccess) {
                    final list = state.response.salesMaster;

                    final totalCount = list.length;
                    final totalAmount = list.fold<double>(
                      0.0,
                      (sum, item) => sum + _toDouble(item.grandTotal),
                    );

                    return Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Sales Count',
                            value: totalCount.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Total Sales Amount',
                            value: totalAmount.toStringAsFixed(2),
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is SalesReportMasterByDateError) {
                    return const Text('Failed to load sales data');
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),

              const SizedBox(height: 14),

              /// CASH BALANCE
              BlocBuilder<SalesReportCubit, SlesReportState>(
                builder: (context, state) {
                  if (state is SalesReportMasterByDateSuccess) {
                    final list = state.response.salesMaster;

                    final cashBalance = list.fold<double>(
                      0.0,
                      (sum, item) => sum + _toDouble(item.cashAmount),
                    );

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
                          Text(
                            cashBalance.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox(height: 100);
                },
              ),

              const SizedBox(height: 18),

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
                  SizedBox(width: 12),
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
                  SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.flag_outlined,
                      label: 'Item Report',
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: SizedBox()),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

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
