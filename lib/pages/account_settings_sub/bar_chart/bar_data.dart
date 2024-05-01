import 'package:prepitpro/pages/account_settings_sub/bar_chart/individual_bar.dart';

class BarData {
  final int passed;
  final int failed;

  BarData({required this.failed, required this.passed});

  List<IndividualBar> barData = [];

  void initializeData(int passed, int failed) {
    barData = [
      IndividualBar(x: 0, y: passed.toDouble(), bar: "passed"),
      IndividualBar(x: 1, y: failed.toDouble(), bar: "failed"),
    ];
  }
}
