import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
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

  // Load environment variables
  await dotenv.load(fileName: ".env");
  print('✅ Environment variables loaded');

  // Initialize Supabase
  await SupabaseService.initialize();
  print('✅ Supabase initialized');

  // Note: Authentication is now handled by AuthBloc
  // Users must log in with: test@ecobin.app / testpassword123

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  // Initialize repositories
  final authRepository = AuthRepository(
    apiClient: ApiClient(),
    storage: storageService,
  );

  final compostRepository = CompostRepository();
  final waterRepository = WaterRepository();

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
          themeMode: ThemeMode.light,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
