import 'package:flutter/material.dart';
import 'package:prepitpro/components/action_button.dart';
import 'package:prepitpro/components/gap.dart';
import 'package:prepitpro/helpers/messenger.dart';
import 'package:prepitpro/pages/account_settings_sub/bar_chart.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/utils/auth.dart';
import 'package:prepitpro/utils/helpers.dart';
import 'package:prepitpro/utils/performance.dart';
import 'package:provider/provider.dart';
import 'package:typeset/typeset.dart';

class PerformancePage extends StatefulWidget {
  final String? title;
  const PerformancePage({super.key, required this.title});
  static const routeName = "/performance";

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  int currentValue = 0;

  @override
  void initState() {
    Future.microtask(() async {
      await _retrieve();
    });

    super.initState();
  }

  Future<void> _retrieve() async {
    final user = context.read<CurrentUser>().user;
    await context
        .read<PerformanceManager>()
        .getUserPerformance(user.id!, user.userClass!);
  }

  Future<void> subjectPerformance(int subjectId) async {
    try {
      final user = context.read<CurrentUser>().user;
      await context.read<PerformanceManager>().getUserPerformancePerSubject(
          user.id!,
          subjectId: subjectId,
          classId: user.userClass);
    } catch (e) {
      if (mounted) {
        Messenger.showSnackBar("error occured", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPerf = context.watch<PerformanceManager>().userPerformance;
    final allUserPerf = context.watch<PerformanceManager>().allUserPerformance;
    final totalQuestions = context.watch<PerformanceManager>().totalQuestions;
    final passedQuestions = context.watch<PerformanceManager>().qeustionsPassed;
    final failedQuestions = context.watch<PerformanceManager>().questionsFailed;
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          ActionButton(
            icon: Icons.close,
            size: 40,
            onTap: () => Navigator.pop(context),
          ),
          const Gap()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(16),
                  color: isDark ? secondaryColor : Colors.amber.shade200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TypeSet(
                    "Total Subject: *${allUserPerf.length}*",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Gap(),
                  const Text("Select subject:"),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        hintText: "Subject",
                        hintStyle: const TextStyle(color: Colors.black54)),
                    items: [
                      const DropdownMenuItem(
                        key: ValueKey(0),
                        value: 0,
                        child: Text("All Subject"),
                      ),
                      if (allUserPerf.isNotEmpty)
                        ...allUserPerf.map(
                          (e) {
                            return DropdownMenuItem(
                              key: ValueKey(e.id),
                              value: e.subject_id,
                              child: Text(UtilsFunctions.getSubjectFromID(
                                  context, e.subject_id)),
                            );
                          },
                        ),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        currentValue = value!;
                      });
                      if (value != 0) {
                        await subjectPerformance(value!);
                      }
                    },
                  )
                ],
              ),
            ),
            const Gap(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark ? secondaryColor : Colors.amber.shade200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Questions:"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${currentValue != 0 ? userPerf.total_questions : totalQuestions}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const Text(
                            "Total Questions",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${currentValue != 0 ? userPerf.questions_passed : passedQuestions}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Text(
                            "Passed",
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${currentValue != 0 ? userPerf.questions_failed : failedQuestions}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Text(
                            "Failed",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Gap(),
            Container(
              padding:
                  const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? secondaryColor.withOpacity(0.5)
                      : Colors.amber.shade100),
              child: PerformanceBarChart(
                  totalQuestions: currentValue != 0
                      ? userPerf.total_questions!
                      : totalQuestions,
                  passedQuestions: currentValue != 0
                      ? userPerf.questions_passed!
                      : passedQuestions,
                  failedQuestions: currentValue != 0
                      ? userPerf.questions_failed!
                      : failedQuestions),
            ),
          ],
        ),
      ),
    ));
  }
}
