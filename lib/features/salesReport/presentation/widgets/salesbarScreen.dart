import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Sales Report")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDailyScrollableChart(),
              const SizedBox(height: 30),
              _buildWeeklyFixedChart(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================
  // 1️⃣ DAILY CHART (SCROLL)
  // ==========================
  Widget _buildDailyScrollableChart() {
    final dailySales =
    List.generate(30, (index) => (index + 1) * 120.0);

    double chartWidth = dailySales.length * 40;

    return _chartCard(
      title: "Daily Sales (30 Days)",
      child: SizedBox(
        height: 260,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: 4000,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 5 == 0) {
                          return Text(
                            '${value.toInt() + 1}',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  dailySales.length,
                      (index) => _makeGroupData(index, dailySales[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  // 2️⃣ WEEKLY CHART (NO SCROLL)
  // ==========================
  Widget _buildWeeklyFixedChart() {
    final weeklySales = [4500.0, 5200.0, 6100.0, 4800.0];

    return _chartCard(
      title: "Weekly Summary",
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 7000,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text("W1");
                      case 1:
                        return const Text("W2");
                      case 2:
                        return const Text("W3");
                      case 3:
                        return const Text("W4");
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(
              weeklySales.length,
                  (index) => _makeGroupData(index, weeklySales[index]),
            ),
          ),
        ),
      ),
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