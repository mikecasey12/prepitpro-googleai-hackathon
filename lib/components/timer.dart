import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typeset/typeset.dart';

class Timer extends StatefulWidget {
  final int? hoursLimit;
  final int? minutesLimit;
  final Function() onSubmit;
  const Timer(
      {super.key,
      this.hoursLimit = 2,
      this.minutesLimit = 30,
      required this.onSubmit});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  void timer() async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (hours >= widget.hoursLimit!) {
        return false;
      }
      if (minutes >= widget.minutesLimit!) {
        return false;
      }
      if (mounted) {
        setState(() {
          seconds += 1;
        });
      }

      if (seconds > 59) {
        if (mounted) {
          setState(() {
            minutes += 1;
            seconds = 0;
          });
        }
      }
      if (minutes > 59) {
        if (mounted) {
          setState(() {
            hours += 1;
            minutes = 0;
          });
        }
      }
      return true;
    });
    widget.onSubmit();
  }

  @override
  void didChangeDependencies() {
    timer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TypeSet(
      "*${hours > 9 ? hours : "0$hours"}:${minutes > 9 ? minutes : "0$minutes"}:${seconds > 9 ? seconds : "0$seconds"}*",
      style: GoogleFonts.anta(
          textStyle: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.secondary)),
    );
  }
}
