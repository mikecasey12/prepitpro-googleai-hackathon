import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prepitpro/pages/account_settings_sub/bar_chart/bar_data.dart';
import 'package:prepitpro/theme/theme.dart';

class PerformanceBarChart extends StatefulWidget {
  final int totalQuestions;
  final int passedQuestions;
  final int failedQuestions;
  const PerformanceBarChart(
      {super.key,
      required this.failedQuestions,
      required this.passedQuestions,
      required this.totalQuestions});

  @override
  State<StatefulWidget> createState() => PerformanceBarChartState();
}

class PerformanceBarChartState extends State<PerformanceBarChart> {
  final double width = 7;
  int touchedGroupIndex = -1;
  late BarData? myBarData;

  @override
  void initState() {
    myBarData =
        BarData(failed: widget.failedQuestions, passed: widget.passedQuestions);

    super.initState();
  }

  List chartItems = [];

  @override
  Widget build(BuildContext context) {
    myBarData!.initializeData(widget.passedQuestions, widget.failedQuestions);
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Questions Chart',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(BarChartData(
                  maxY: widget.totalQuestions.toDouble(),
                  minY: 0,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              getTitlesWidget: bottomTitles,
                              showTitles: true))),
                  barGroups: myBarData!.barData
                      .map(
                        (e) => BarChartGroupData(x: e.x, barRods: [
                          BarChartRodData(
                            toY: e.y,
                            color:
                                e.bar == "passed" ? Colors.green : Colors.red,
                            width: 24,
                            borderRadius: BorderRadius.circular(4),
                            backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.grey.shade100,
                                show: true,
                                toY: widget.totalQuestions.toDouble()),
                          )
                        ]),
                      )
                      .toList())),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    TextStyle style = const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 19) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Passed', 'Failed'];

    final Widget text = Text(
      titles[value.toInt()],
      style: TextStyle(
        color: ThemeController.themeMode.value == ThemeMode.dark
            ? Theme.of(context).colorScheme.secondary
            : const Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4, //margin top
      child: text,
    );
  }
}
