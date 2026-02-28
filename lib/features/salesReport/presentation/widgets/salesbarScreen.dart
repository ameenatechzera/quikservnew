import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:quikservnew/features/settings/domain/entities/monthlyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/entities/weeklyGraphReportResult.dart';
import 'package:quikservnew/features/settings/domain/parameters/barGraphRequest.dart';
import 'package:quikservnew/features/settings/presentation/bloc/settings_cubit.dart';

List<MonthlyReportList>monthlyList =[];
List<WeeklyList>weeklyList =[];
List<MonthlyReportList>yearlyList =[];
List<MonthlyReportList>dailyList =[];
class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SettingsCubit>().fetchDailyGraphFromServer(
        BarGraphRequest(period: 'hourly', branchId: '1'));

    // context.read<SettingsCubit>().fetchWeeklyGraphFromServer(
    //     BarGraphRequest(period: 'weekly', branchId: '1'));

    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailyFixedChart(),
              const SizedBox(height: 30),
              _buildWeeklyFixedChart(),
              const SizedBox(height: 30),
              _buildMonthlyFixedChart(),
              const SizedBox(height: 30),
              _buildYearlyFixedChart()
            ],
          ),
        ),
      ),
    );
  }

  // ==========================
  // 1️⃣ DAILY CHART (SCROLL)
  // ==========================
  // ==========================
  // 2️⃣ MONTHLY CHART (NO SCROLL)
  // ==========================
  Widget _buildDailyFixedChart() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is FetchDailyGraphSuccess) {
          dailyList.clear();
          dailyList.addAll(state.dailyGraphResult.data);
          context.read<SettingsCubit>().fetchWeeklyGraphFromServer(
              BarGraphRequest(period: 'weekly', branchId: '1'));
        }
      },
      builder: (context, state) {
        if (dailyList.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔹 Find maxY dynamically
        double maxY = dailyList
            .map((e) => double.tryParse(e.value.toString()) ?? 0)
            .reduce((a, b) => a > b ? a : b);

        maxY = maxY + (maxY * 0.2); // Add 20% top space

        return _chartCard(
          title: "Daily Summary",
          child: SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),
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
                barGroups: List.generate(
                  dailyList.length,
                      (index) {
                    double yValue =
                        double.tryParse(dailyList[index].value.toString()) ?? 0;

                    return _makeGroupData(index, yValue);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================
  // 2️⃣ MONTHLY CHART (NO SCROLL)
  // ==========================
  Widget _buildMonthlyFixedChart() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is FetchMonthlyGraphSuccess) {
          monthlyList.clear();
          monthlyList.addAll(state.monthlyGraphResult.data);
          context.read<SettingsCubit>().fetchYearlyGraphFromServer(
              BarGraphRequest(period: 'yearly', branchId: '1'));
        }
      },
      builder: (context, state) {
        if (monthlyList.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔹 Find maxY dynamically
        double maxY = monthlyList
            .map((e) => double.tryParse(e.value.toString()) ?? 0)
            .reduce((a, b) => a > b ? a : b);

        maxY = maxY + (maxY * 0.2); // Add 20% top space

        return _chartCard(
          title: "Monthly Summary",
          child: SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < monthlyList.length) {
                          return Text(
                            monthlyList[index].name.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  monthlyList.length,
                      (index) {
                    double yValue =
                        double.tryParse(monthlyList[index].value.toString()) ?? 0;

                    return _makeGroupData(index, yValue);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================
  // 2️⃣ WEEKLY CHART (NO SCROLL)
  // ==========================
  Widget _buildWeeklyFixedChart() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is FetchWeeklyGraphSuccess) {
          weeklyList.clear();
          weeklyList.addAll(state.weeklyGraphResult.data);
          context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
              BarGraphRequest(period: 'monthly', branchId: '1'));
        }
      },
      builder: (context, state) {
        if (weeklyList.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔹 Find maxY dynamically
        double maxY = weeklyList
            .map((e) => double.tryParse(e.value.toString()) ?? 0)
            .reduce((a, b) => a > b ? a : b);

        maxY = maxY + (maxY * 0.2); // Add 20% top space

        return _chartCard(
          title: "Weekly Summary",
          child: SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < weeklyList.length) {
                          return Text(
                            weeklyList[index].name.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  weeklyList.length,
                      (index) {
                    double yValue =
                        double.tryParse(weeklyList[index].value.toString()) ?? 0;

                    return _makeGroupData(index, yValue);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================
  // 2️⃣ Yearly CHART (NO SCROLL)
  // ==========================
  Widget _buildYearlyFixedChart() {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is FetchYearlyGraphSuccess) {
          yearlyList.clear();
          yearlyList.addAll(state.monthlyGraphResult.data);
          // context.read<SettingsCubit>().fetchMonthlyGraphFromServer(
          //     BarGraphRequest(period: 'monthly', branchId: '1'));
        }
      },
      builder: (context, state) {
        if (yearlyList.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔹 Find maxY dynamically
        double maxY = yearlyList
            .map((e) => double.tryParse(e.value.toString()) ?? 0)
            .reduce((a, b) => a > b ? a : b);

        maxY = maxY + (maxY * 0.2); // Add 20% top space

        return _chartCard(
          title: "Yearly Summary",
          child: SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < yearlyList.length) {
                          return Text(
                            yearlyList[index].name.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  yearlyList.length,
                      (index) {
                    double yValue =
                        double.tryParse(yearlyList[index].value.toString()) ?? 0;

                    return _makeGroupData(index, yValue);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================
  // COMMON BAR GROUP
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
  // CHART CARD UI
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
}