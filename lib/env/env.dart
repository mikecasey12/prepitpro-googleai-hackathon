// lib/env/env.dart
// ignore_for_file: constant_identifier_names

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: "AI_API_KEY")
  static const String AI_API_KEY = _Env.AI_API_KEY;
  @EnviedField()
  static const String SUPABASE_URL = _Env.SUPABASE_URL;
  @EnviedField()
  static const String SUPABASE_ANON_KEY = _Env.SUPABASE_ANON_KEY;
  @EnviedField(varName: "GOOGLE_WEB_CLIENT_ID")
  static const String GOOGLE_WEB_CLIENT_ID = _Env.GOOGLE_WEB_CLIENT_ID;
}
