import 'package:flutter/material.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/pages/account_settings_sub/favorites.dart';
import 'package:prepitpro/pages/account_settings_sub/history.dart';
import 'package:prepitpro/pages/account_settings_sub/performance.dart';
import 'package:prepitpro/pages/answer_review.dart';
import 'package:prepitpro/pages/auth/account_complete.dart';
import 'package:prepitpro/pages/auth/auth.dart';
import 'package:prepitpro/pages/auth/forgot_password.dart';
import 'package:prepitpro/pages/auth/signup.dart';
import 'package:prepitpro/pages/customize_test.dart';
import 'package:prepitpro/pages/error_404.dart';
import 'package:prepitpro/pages/generated_answer_review.dart';
import 'package:prepitpro/pages/generated_questions.dart';
import 'package:prepitpro/pages/generated_questions_practice.dart';
import 'package:prepitpro/pages/homepage.dart';
import 'package:prepitpro/pages/loading.dart';
import 'package:prepitpro/pages/notifications.dart';
import 'package:prepitpro/pages/onboarding/onboarding.dart';
import 'package:prepitpro/pages/search.dart';
import 'package:prepitpro/pages/settings.dart';
import 'package:prepitpro/pages/subjects.dart';
import 'package:prepitpro/pages/test.dart';
import 'package:prepitpro/pages/test_practice.dart';
import 'package:prepitpro/pages/test_selection.dart';
import 'package:prepitpro/pages/account_settings_sub/update_user_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const bool onboarded = true;

Route<dynamic> appRoute(
    RouteSettings settings, AsyncSnapshot<AuthState>? snapshot) {
  if (snapshot!.connectionState == ConnectionState.waiting) {
    return MaterialPageRoute(builder: (context) => const LoadingPage());
  }
  final session = DBInit.supabase.auth.currentSession;
  final currentUser = DBInit.supabase.auth.currentUser?.userMetadata;
  if (snapshot.connectionState == ConnectionState.active && session != null) {
    if (currentUser!["accountCompleted"] == null ||
        !currentUser["accountCompleted"]) {
      return MaterialPageRoute(
          settings: settings, builder: (context) => const AccountComplete());
    } else {
      switch (settings.name) {
        case HomePage.routeName:
          return MaterialPageRoute(builder: (context) => const HomePage());
        case NotificationsPage.routeName:
          return MaterialPageRoute(
              builder: (context) => const NotificationsPage());
        case SubjectsPage.routeName:
          return MaterialPageRoute(builder: (context) => const SubjectsPage());
        case TestSelectionPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const TestSelectionPage());
        case TestPracticePage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const TestPracticePage());
        case AnswerReviewPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const AnswerReviewPage());
        case TestPage.routeName:
          return MaterialPageRoute(
              settings: settings, builder: (context) => const TestPage());
        case CustomizeTestPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const CustomizeTestPage());
        case GeneratedQuestionsPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const GeneratedQuestionsPage());
        case GeneratedQuestionsPracticePage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const GeneratedQuestionsPracticePage());
        case GeneratedAnswerReviewPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => const GeneratedAnswerReviewPage());
        case SettingsPage.routeName:
          return MaterialPageRoute(
              settings: settings, builder: (context) => const SettingsPage());
        case ChangePassword.routeName:
          return MaterialPageRoute(
              settings: settings, builder: (context) => const ChangePassword());
        case SearchPage.routeName:
          return MaterialPageRoute(
              settings: settings, builder: (context) => const SearchPage());
        case HistoryPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => HistoryPage(
                    title: settings.arguments! as String,
                  ));
        case PerformancePage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => PerformancePage(
                    title: settings.arguments! as String,
                  ));
        case FavoritesPage.routeName:
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => FavoritesPage(
                    title: settings.arguments! as String,
                  ));

        default:
          return MaterialPageRoute(
            builder: (context) => const Error404Page(),
          );
      }
    }
  } else if (snapshot.connectionState == ConnectionState.active &&
      session == null) {
    switch (settings.name) {
      case AuthPage.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const AuthPage());
      case SignupPage.routeName:
        return MaterialPageRoute(
            settings: settings, builder: (context) => const SignupPage());
      case ForgotPasswordPage.routeName:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => const ForgotPasswordPage());
      default:
        return MaterialPageRoute(
          builder: (context) =>
              onboarded ? const AuthPage() : const OnboardingPage(),
        );
    }
  } else {
    print("Here in the last else");
    return MaterialPageRoute(
      builder: (context) => const HomePage(),
    );
  }
}
