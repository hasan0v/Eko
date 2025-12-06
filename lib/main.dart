import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/services/api_client.dart';
import 'core/services/storage_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/auth/logic/auth_event.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/compost/data/compost_repository.dart';
import 'features/compost/logic/compost_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  
  runApp(EcoBinApp(
    authRepository: authRepository,
    compostRepository: compostRepository,
  ));
}

class EcoBinApp extends StatelessWidget {
  final AuthRepository authRepository;
  final CompostRepository compostRepository;

  const EcoBinApp({
    super.key,
    required this.authRepository,
    required this.compostRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository)
            ..add(const AuthCheckStatus()),
        ),
        BlocProvider(
          create: (context) => CompostBloc(compostRepository: compostRepository),
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
    );
  }
}
