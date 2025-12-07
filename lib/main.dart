import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/database/local_database.dart';
import 'core/database/database_seeder.dart';
import 'core/services/api_client.dart';
import 'core/services/storage_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/auth/logic/auth_event.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/compost/data/compost_repository.dart';
import 'features/compost/logic/compost_bloc.dart';
import 'features/water/data/water_repository.dart';
import 'features/water/logic/water_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local database
  final localDb = LocalDatabase();
  await localDb.initialize();

  // Seed database with sample data (only on first run)
  final isFirstRun =
      localDb.getSetting('is_first_run', defaultValue: true) as bool;
  if (isFirstRun) {
    await DatabaseSeeder.seedAll();
    await localDb.saveSetting('is_first_run', false);
  }

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final apiClient = ApiClient();

  // Initialize repositories
  final authRepository = AuthRepository(
    apiClient: apiClient,
    storage: storageService,
  );

  final compostRepository = CompostRepository(apiClient: apiClient);
  final waterRepository = WaterRepository(apiClient: apiClient);

  runApp(
    EcoBinApp(
      authRepository: authRepository,
      compostRepository: compostRepository,
      waterRepository: waterRepository,
    ),
  );
}

class EcoBinApp extends StatelessWidget {
  final AuthRepository authRepository;
  final CompostRepository compostRepository;
  final WaterRepository waterRepository;

  const EcoBinApp({
    super.key,
    required this.authRepository,
    required this.compostRepository,
    required this.waterRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CompostRepository>.value(value: compostRepository),
        RepositoryProvider<WaterRepository>.value(value: waterRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    AuthBloc(authRepository: authRepository)
                      ..add(const AuthCheckStatus()),
          ),
          BlocProvider(
            create:
                (context) => CompostBloc(compostRepository: compostRepository),
          ),
          BlocProvider(
            create: (context) => WaterBloc(waterRepository: waterRepository),
          ),
        ],
        child: MaterialApp(
          title: 'EcoBin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
