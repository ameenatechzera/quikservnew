import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/salesCountGraphResult.dart';
import 'package:quikservnew/features/settings/domain/entities/weeklyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/domain/parameters/customSalesGraphRequest.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

List<SaleCountGraphList>salesCountList =[];
List<MonthlyReportList>dailyList =[];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalesTypeSelector(),
              _buildSalesChart()
            ],
          ),
        ),
      ),
    );
  }


  // ==========================
  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          borderRadius: BorderRadius.circular(6),
          color: Colors.blue,
        ),
      ],
    );
  }

  // ==========================
  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

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
                    if(period=='daily'){
                      period ='hourly';
                    }
                    print('Hr ${selectedView.name}');
                    if(selectedView.name =='amount'){
                      context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
                        BarGraphRequest(
                          period: period,
                          branchId: '1',
                        ),
                      );
                    }
                    else {
                      context.read<SettingsCubit>().fetchSalesCountFromServer(
                        BarGraphRequest(
                          period: period,
                          branchId: '1',
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

        /// 🔹 Chart Section
        _buildChartBody(),
      ],
    );
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

                // 🔥 Call API if needed
                // fetchGraph(viewType: "amount");
              },
            ),
            const Text(
              "Sales Amount",
              style: TextStyle(fontSize: 14),
            ),
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
            const Text(
              "Sales Count",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
  // Widget _buildChartBody() {
  //   return BlocConsumer<SettingsCubit, SettingsState>(
  //     listener: (context, state) {
  //
  //       if (state is FetchDailyGraphSuccess) {
  //         dailyList.clear();
  //         dailyList.addAll(state.graphResult.data);
  //         // context.read<SettingsCubit>().fetchWeeklyGraphFromServer(
  //         //     BarGraphRequest(period: 'weekly', branchId: '1'));
  //       }
  //       if (state is FetchWeeklyGraphSuccess) {
  //         dailyList.clear();
  //         dailyList.addAll(state.graphResult.data);
  //       }
  //       if (state is FetchMonthlyGraphSuccess) {
  //         dailyList.clear();
  //         dailyList.addAll(state.graphResult.data);
  //       }
  //       if (state is FetchYearlyGraphSuccess) {
  //         dailyList.clear();
  //         dailyList.addAll(state.graphResult.data);
  //       }
  //       if(state is FetchSalesCountGraphSuccess){
  //         salesCountList.clear();
  //         salesCountList.addAll(state.graphResult.data);
  //       }
  //     },
  //     builder: (context, state) {
  //       if (dailyList.isEmpty) {
  //         return SizedBox(
  //           height: 260,
  //           child: Center(child: Text('No Data Found..!')),
  //         );
  //       }
  //
  //       double maxY = dailyList
  //           .map((e) => double.tryParse(e.value.toString()) ?? 0)
  //           .reduce((a, b) => a > b ? a : b);
  //
  //       maxY = maxY + (maxY * 0.2);
  //
  //       return _chartCard(
  //         title: "",
  //         child: SizedBox(
  //           height: 260,
  //           child: BarChart(
  //             BarChartData(
  //               alignment: BarChartAlignment.spaceAround,
  //               maxY: maxY,
  //               borderData: FlBorderData(show: false),
  //               titlesData: FlTitlesData(
  //                 leftTitles: AxisTitles(
  //                   sideTitles: SideTitles(showTitles: true),
  //                 ),
  //                 bottomTitles: AxisTitles(
  //                   sideTitles: SideTitles(
  //                     showTitles: true,
  //                     getTitlesWidget: (value, meta) {
  //                       int index = value.toInt();
  //                       if (index >= 0 && index < dailyList.length) {
  //                         return Text(
  //                           dailyList[index].name.toString(),
  //                           style: const TextStyle(fontSize: 10),
  //                         );
  //                       }
  //                       return const SizedBox();
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               barGroups: List.generate(
  //                 dailyList.length,
  //                     (index) {
  //                   double yValue =
  //                       double.tryParse(dailyList[index].value.toString()) ?? 0;
  //                   return _makeGroupData(index, yValue);
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
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
              if(state is FetchSalesCountGraphSuccess){
                salesCountList.clear();
                salesCountList.addAll(state.graphResult.data);
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
                    final index =
                        response.spot!.touchedBarGroupIndex;

                    final selectedItem = dailyList[index];

                    print("Clicked: ${selectedItem.name}");
                    context.read<SettingsCubit>().fetchCustomSalesGraphFromServer(
                      CustomSalesGraphRequest(
                        period: 'custom',
                        branchId: '1', fromDate: "", toDate: "", month: "", year: '2026', week: '1',
                      ),
                    );

                    /// 🔥 Drill down logic
                    if (selectedPeriod == SalesPeriod.yearly) {
                      selectedPeriod = SalesPeriod.monthly;
                    } else if (selectedPeriod ==
                        SalesPeriod.monthly) {
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
                      if (index >= 0 &&
                          index < dailyList.length) {
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

              barGroups: List.generate(
                dailyList.length,
                    (index) {
                  double yValue =
                      double.tryParse(
                          dailyList[index].value.toString()) ??
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
                },
              ),
            ),
          ),
        );
      },
    );
  }

}