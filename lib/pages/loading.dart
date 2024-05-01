import 'package:flutter/material.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/pages/homepage.dart';
import 'package:prepitpro/pages/onboarding/onboarding.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  static const routeName = "/loading";

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    _redirect();
    super.initState();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = DBInit.supabase.auth.currentSession;
    if (session != null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, OnboardingPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
