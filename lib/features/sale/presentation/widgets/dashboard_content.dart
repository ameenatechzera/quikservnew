import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/screens/dailyCloseReportScreen.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/screens/itemwise_report_screen.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/screens/payment_voucher.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_screen.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/sales_masterreport_bydate_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesReportScreen.dart';

// ✅ add this (same used in HomeScreen)
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/salesbarScreen.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';

import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/customSalesGraphRequest.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final DateFormat formatter = DateFormat('dd MMM yyyy');
List<SaleCountGraphList> salesCountList = [];
List<MonthlyReportList> dailyList = [];
List<MonthlyGraphReportResult> customGraphList = [];
DateTime? fromDate;
DateTime? toDate;
bool isCustomSelected = false;
final TextEditingController fromController = TextEditingController();
final TextEditingController toController = TextEditingController();

enum SalesPeriod { daily, weekly, monthly, yearly }

enum SalesViewType { amount, count }
 int currentYear = 0;
String stBranchId = '1';

SalesViewType selectedView = SalesViewType.amount;
SalesPeriod selectedPeriod = SalesPeriod.daily;

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
    currentYear = DateTime.now().year;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // SubscriptionService.validateSubscription(context);
      _fetchReport();
    });

    // WidgetsBinding.instance.addObserver(this);

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

  Future<void> _fetchReport() async {
    final fromDate = DateFormat('yyyy-MM-dd').format(fromDateNotifier.value);
    final toDate = DateFormat('yyyy-MM-dd').format(toDateNotifier.value);
    final prefs = await SharedPreferences.getInstance();
    stBranchId = await SharedPreferenceHelper().getBranchId();
    print('stBranchId $stBranchId');
    context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
      BarGraphRequest(period: 'daily', branchId: '1'),
    );
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                          icon: Icons.receipt_long_outlined,
                          label: 'Sales Invoice',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.camera_alt_outlined,
                          label: 'Payment',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(pagefrom: ''),
                              ),
                            );
                          },
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => const MonthlyReportPage(),
                            //   ),
                            // );
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

                  const SizedBox(height: 24),
                  // ✅ some bottom space
                  _buildCustomSelector(),
                  _buildSalesTypeSelector(),
                  _buildSalesChart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Chart Section
        _buildChartBody(),
      ],
    );
  }

  Widget _buildCustomSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Heading + Dropdown Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sales Graph",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        /// 🔹 Only One Checkbox
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isCustomSelected,
                  onChanged: (value) {
                    setState(() {
                      isCustomSelected = value ?? false;

                      if (!isCustomSelected) {
                        fromDate = null;
                        toDate = null;
                        fromController.clear();
                        toController.clear();
                      }
                    });
                  },
                ),
                const Text("Custom", style: TextStyle(fontSize: 14)),
              ],
            ),
            if (!isCustomSelected)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🔹 Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<SalesPeriod>(
                        value: selectedPeriod,
                        underline: const SizedBox(),
                        onChanged: (SalesPeriod? newValue) {
                          if (newValue == null) return;

                          setState(() {
                            selectedPeriod = newValue;
                          });

                          /// 🔥 Call API based on selection
                          String period = newValue.name; // daily, weekly...
                          if (selectedView.name == 'count') {
                            if (period == 'daily') {
                              period = 'hourly';
                            }
                          }

                          print('Hr ${selectedView.name}');
                          print('ClickedHR ${selectedView.name}');
                          if (selectedView.name == 'amount') {
                            context
                                .read<SettingsCubit>()
                                .fetchMonthlyGraphFromServer(
                                  BarGraphRequest(
                                    period: period,
                                    branchId: stBranchId,
                                  ),
                                );
                          } else {
                            context
                                .read<SettingsCubit>()
                                .fetchSalesCountFromServer(
                                  BarGraphRequest(
                                    period: period,
                                    branchId: stBranchId,
                                  ),
                                );
                          }
                        },
                        items: SalesPeriod.values.map((period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(
                              period.name.toUpperCase(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        /// 🔹 Show Date Fields Only When Checked
        if (isCustomSelected)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: fromController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "From (dd-MM-yyyy)",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onTap: () => _pickDate2(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: toController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "To (dd-MM-yyyy)",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onTap: () => _pickDate2(false),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _onCustomDateChanged() {
    if (!isCustomSelected) return;

    if (fromDate != null && toDate != null) {
      if (toDate!.isBefore(fromDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("To Date cannot be before From Date")),
        );
        return;
      }

      final fromApi = DateFormat('yyyy-MM-dd').format(fromDate!);
      final toApi = DateFormat('yyyy-MM-dd').format(toDate!);

      print("From: $fromApi");
      print("To: $toApi");

      /// 🔥 CALL YOUR API HERE

      context.read<SettingsCubit>().fetchCustomSalesGraphFromServer(
        CustomSalesGraphRequest(
          period: 'custom',
          branchId: stBranchId,
          fromDate: fromApi,
          toDate: toApi,
          month: "",
          year: currentYear.toString(),
          week: '1',
          salesType: selectedView.name,
        ),
      );
    }
  }

  Widget _buildSalesTypeSelector() {
    return Row(
      children: [
        /// 🔹 Sales Amount Checkbox
        Row(
          children: [
            Checkbox(
              value: selectedView == SalesViewType.amount,
              onChanged: (value) {
                setState(() {
                  selectedView = SalesViewType.amount;
                });
                if (isCustomSelected){
                  final fromApi = DateFormat('yyyy-MM-dd').format(fromDate!);
                  final toApi = DateFormat('yyyy-MM-dd').format(toDate!);

                  print("From: $fromApi");
                  print("To: $toApi");

                  context.read<SettingsCubit>().fetchCustomSalesGraphFromServer(
                    CustomSalesGraphRequest(
                      period: 'custom',
                      branchId: stBranchId,
                      fromDate: fromApi,
                      toDate: toApi,
                      month: "",
                      year: currentYear.toString(),
                      week: '1',
                      salesType: selectedView.name,
                    ),
                  );
                }
                else {
                  context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
                    BarGraphRequest(period: selectedPeriod.name, branchId: '1'),
                  );
                }

                // 🔥 Call API if needed
                // fetchGraph(viewType: "amount");
              },
            ),
            const Text("Sales Amount", style: TextStyle(fontSize: 14)),
          ],
        ),

        const SizedBox(width: 20),

        /// 🔹 Sales Count Checkbox
        Row(
          children: [
            Checkbox(
              value: selectedView == SalesViewType.count,
              onChanged: (value) {
                setState(() {
                  selectedView = SalesViewType.count;
                });
                if (isCustomSelected){
                  final fromApi = DateFormat('yyyy-MM-dd').format(fromDate!);
                  final toApi = DateFormat('yyyy-MM-dd').format(toDate!);

                  print("From: $fromApi");
                  print("To: $toApi");

                  context.read<SettingsCubit>().fetchCustomSalesGraphFromServer(
                    CustomSalesGraphRequest(
                      period: 'custom',
                      branchId: stBranchId,
                      fromDate: fromApi,
                      toDate: toApi,
                      month: "",
                      year: currentYear.toString(),
                      week: '1',
                      salesType: selectedView.name,
                    ),
                  );
                }
                else {
                  context.read<SettingsCubit>().fetchSalesCountFromServer(
                    BarGraphRequest(period: selectedPeriod.name, branchId: stBranchId),
                  );
                }
                // 🔥 Call API if needed
                // fetchGraph(viewType: "count");
              },
            ),
            const Text("Sales Count", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  /// 🔹 CHART SECTION
  Widget _buildChartBody() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is FetchDailyGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.graphResult.data);
          // context.read<SettingsCubit>().fetchWeeklyGraphFromServer(
          //     BarGraphRequest(period: 'weekly', branchId: '1'));
        }
        if (state is FetchWeeklyGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.graphResult.data);
        }
        if (state is FetchMonthlyGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.graphResult.data);
        }
        if (state is FetchYearlyGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.graphResult.data);
        }
        if (state is FetchSalesCountGraphSuccess) {
          salesCountList.clear();
          salesCountList.addAll(state.graphResult.data);
        }
        if (state is FetchCustomSalesGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.graphResult.data);
        }
      },
      builder: (context, state) {
        if (dailyList.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: Text('No Data Found..!')),
          );
        }

        double maxY = dailyList
            .map((e) => double.tryParse(e.value.toString()) ?? 0)
            .reduce((a, b) => a > b ? a : b);

        maxY = maxY + (maxY * 0.2);
        if (state is FetchSalesCountGraphSuccess) {
          return SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),

                /// 🔥 BAR CLICK HANDLER
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      final index = response.spot!.touchedBarGroupIndex;

                      final selectedItem = salesCountList[index];
                      print('period ${selectedPeriod.name}');

                      print("ClickedHere: ${selectedItem.name}");
                      String? monthNumber = getMonthNumber(selectedItem.name);
                      context
                          .read<SettingsCubit>()
                          .fetchCustomSalesGraphFromServer(
                            CustomSalesGraphRequest(
                              period: 'custom',
                              branchId: stBranchId,
                              fromDate: "",
                              toDate: "",
                              month: monthNumber,
                              year: currentYear.toString(),
                              week: '1',
                            ),
                          );

                      /// 🔥 Drill down logic
                      if (selectedPeriod == SalesPeriod.yearly) {
                        selectedPeriod = SalesPeriod.monthly;
                      } else if (selectedPeriod == SalesPeriod.monthly) {
                        selectedPeriod = SalesPeriod.daily;
                      }

                      setState(() {});
                      // _fetchGraph(
                      //     drillValue: selectedItem.name.toString());
                    }
                  },
                ),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < salesCountList.length) {
                          return Text(
                            salesCountList[index].name.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(salesCountList.length, (index) {
                  double yValue =
                      double.tryParse(salesCountList[index].value.toString()) ??
                      0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: yValue,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),

                /// 🔥 BAR CLICK HANDLER
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      final index = response.spot!.touchedBarGroupIndex;

                      final selectedItem = dailyList[index];

                      print("ClickedBar: ${selectedItem.name}");
                      print('period ${selectedPeriod.name}');
                      String? monthNumber = getMonthNumber(selectedItem.name);
                      print('monthNumber ${monthNumber}');
                      context
                          .read<SettingsCubit>()
                          .fetchCustomSalesGraphFromServer(
                            CustomSalesGraphRequest(
                              period: 'custom',
                              branchId: stBranchId,
                              fromDate: "",
                              toDate: "",
                              month: monthNumber,
                              year: currentYear.toString(),
                              week: '1',
                            ),
                          );


                      /// 🔥 Drill down logic
                      if (selectedPeriod == SalesPeriod.yearly) {
                        selectedPeriod = SalesPeriod.monthly;
                      } else if (selectedPeriod == SalesPeriod.monthly) {
                        selectedPeriod = SalesPeriod.daily;
                      }

                      setState(() {});
                      // _fetchGraph(
                      //     drillValue: selectedItem.name.toString());
                    }
                  },
                ),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < dailyList.length) {
                          return Text(
                            dailyList[index].name.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(dailyList.length, (index) {
                  double yValue =
                      double.tryParse(dailyList[index].value.toString()) ?? 0;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: yValue,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        }
      },
    );
  }

  String? getMonthNumber(String? monthName) {
    if (monthName == null || monthName.trim().isEmpty) return null;

    const monthMap = {
      "jan": "1",
      "feb": "2",
      "mar": "3",
      "apr": "4",
      "may": "5",
      "jun": "6",
      "jul": "7",
      "aug": "8",
      "sep": "9",
      "oct": "10",
      "nov": "11",
      "dec": "12",
    };

    return monthMap[monthName.toLowerCase()];
  }

  Future<void> _pickDate2(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          fromController.text = DateFormat('dd-MM-yyyy').format(picked);
        } else {
          toDate = picked;
          toController.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
    _onCustomDateChanged();
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
