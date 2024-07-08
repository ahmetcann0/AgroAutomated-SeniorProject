import 'package:agroautomated/dataPoints.dart';
import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/widgets/app_text_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<SensorDataPoint> points;

  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double minValue =
        points.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    double maxValue =
        points.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 30, 5),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white60,
            lineBarsData: [
              LineChartBarData(
                shadow: Shadow(color: AppTheme.darkTheme.primaryColor),
                spots: List.generate(
                  points.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    points[index].value,
                  ),
                ),
                isCurved: false,
                color: AppTheme.darkTheme.primaryColor,
                dotData: FlDotData(show: false),
              )
            ],
            minY: (minValue - 3).truncate().toDouble(),
            maxY: (maxValue * 1.1 + 2).truncate().toDouble(),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 40,
                  showTitles: true,
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 40,
                  showTitles: true,
                  getTitlesWidget: getTitlesWidgetWeek,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitlesWidgetWeek(double value, TitleMeta meta) {
    // Display the rounded index value as the title
    final int index = value.round();

    // Create a Transform.rotate to rotate the text by 60 degrees
    return Transform.rotate(
      angle:
          -1 * 3.14 / 3, // Rotate the text by 60 degrees clockwise (in radians)
      child: AppText(
        text: index.toString(), // Display the index value

        fontSize: 14, // Customize font size
        fontWeight: FontWeight.bold, // Customize font weight
      ),
    );
  }
}
