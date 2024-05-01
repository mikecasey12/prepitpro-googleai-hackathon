import "dart:io";

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:prepitpro/db/local_db.dart';
import 'package:prepitpro/firebase_options.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/providers/provider_manager.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:prepitpro/theme/theme_manager.dart';
import 'package:prepitpro/utils/notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prepitpro/routes/routes.dart';
import "package:prepitpro/env/env.dart";
import "package:prepitpro/helpers/cert.dart";
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  tz.initializeTimeZones();
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseInstallations installations = FirebaseInstallations.instance;
  String id = await installations.getId();
  print(id);
  await Supabase.initialize(
      url: Env.SUPABASE_URL, anonKey: Env.SUPABASE_ANON_KEY);

  await NotificationsManager.firebaseNotificationInit();
  await LocalDbController.localDBInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        stream: DBInit.supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          return ProviderManager(
            child: ValueListenableBuilder(
              valueListenable: ThemeController.themeMode,
              builder: (context, themeMode, child) => MaterialApp(
                title: "PrepIt Pro",
                color: Colors.amber,
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeManager.darkTheme,
                theme: ThemeManager.lightTheme,
                themeMode: themeMode,
                onGenerateRoute: (settings) {
                  return appRoute(settings, snapshot);
                },
              ),
            ),
          );
        });
  }
}
