import 'package:flutter/material.dart';
import 'core/config/supabase_config.dart';
import 'core/services/supabase_service.dart';
import 'utils/database_seeder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Initializing Supabase...');

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  print('✅ Supabase initialized');

  // Initialize service
  await SupabaseService.instance.initialize();

  // Attempt anonymous sign-in
  try {
    if (!SupabaseService.instance.isAuthenticated) {
      print('🔐 Signing in anonymously...');
      await SupabaseService.instance.signInAnonymously();
      print('✅ Signed in: ${SupabaseService.instance.currentUserId}');
    } else {
      print('✅ Already authenticated: ${SupabaseService.instance.currentUserId}');
    }
  } catch (e) {
    print('⚠️  Authentication error: $e');
  }

  // Seed database
  print('\n📦 Starting database seeding...\n');
  
  try {
    await DatabaseSeeder.seedAll();
    print('\n✨ All done! Database seeded successfully.\n');
  } catch (e, stackTrace) {
    print('\n❌ Seeding failed: $e');
    print('Stack trace: $stackTrace');
  }

  // Exit
  print('Exiting...');
  return;
}
