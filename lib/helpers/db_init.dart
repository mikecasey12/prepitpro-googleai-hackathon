import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DBInit {
  static SupabaseClient supabase = Supabase.instance.client;
}
