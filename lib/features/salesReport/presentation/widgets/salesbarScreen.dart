import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';
import 'package:quikservnew/features/settings/domain/entities/weeklyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/customSalesGraphRequest.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

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

SalesViewType selectedView = SalesViewType.amount;
SalesPeriod selectedPeriod = SalesPeriod.daily;

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  @override
  void initState() {
    context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
      BarGraphRequest(period: 'daily', branchId: '1'),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildCustomSelector(),_buildSalesTypeSelector(), _buildSalesChart()],

          ),
        ),
      ),
    );
  }



  Widget _buildSalesChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Heading + Dropdown Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

        /// 🔹 Chart Section
        _buildChartBody(),
      ],
    );
  }
  Widget _buildCustomSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                const Text(
                  "Custom",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            if (!isCustomSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

                        // print('Hr ${selectedView.name}');
                        // print('ClickedHR ${selectedView.name}');
                       // if (selectedView.name == 'amount') {
                          context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
                            BarGraphRequest(period: period, branchId: '1'),
                          );
                       // } else {

                       // }
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
                  onTap: () => _pickDate(true),
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
                  onTap: () => _pickDate(false),
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
          const SnackBar(
            content: Text("To Date cannot be before From Date"),
          ),
        );
        return;
      }

      final fromApi =
      DateFormat('yyyy-MM-dd').format(fromDate!);
      final toApi =
      DateFormat('yyyy-MM-dd').format(toDate!);

      print("From: $fromApi");
      print("To: $toApi");


      context
          .read<SettingsCubit>()
          .fetchCustomSalesGraphFromServer(
        CustomSalesGraphRequest(
          period: 'custom',
          branchId: '1',
          fromDate: fromApi,
          toDate: toApi,
          month: "",
          year: '2026',
          week: '1',
          salesType: selectedView.name
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

                  context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
                    BarGraphRequest(period: selectedPeriod.name, branchId: '1'),
                  );

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
        if(state is FetchCustomSalesGraphSuccess){
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
                      branchId: '1',
                      fromDate: "",
                      toDate: "",
                      month: monthNumber,
                      year: '2026',
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
                  double.tryParse(salesCountList[index].value.toString()) ?? 0;

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
    else{
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
                      branchId: '1',
                      fromDate: "",
                      toDate: "",
                      month: monthNumber,
                      year: '2026',
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
  Future<void> _pickDate(bool isFrom) async {
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
          fromController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        } else {
          toDate = picked;
          toController.text =
              DateFormat('dd-MM-yyyy').format(picked);
        }
      });
    }
    _onCustomDateChanged();
  }
}
