import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:twin_finder/core/router/router.dart';
import 'package:twin_finder/core/utils/di.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/repository/auth_repository.dart';
import 'package:twin_finder/features/splash/presentation/pages/splash_screen.dart';
import 'package:twin_finder/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),

    Future.delayed(const Duration(seconds: 2)), // Минимальное время показа
  ]);
  await setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthRepository(sl))),
        BlocProvider(create: (_) => LanguageCubit()),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          final currentLanguage = languageState is LanguageLoadedState
              ? languageState.currentLanguage
              : 'en';

          return ToastificationWrapper(
            child: MaterialApp(
              title: 'Twin Finder',
              debugShowCheckedModeBanner: false,
              locale: Locale(currentLanguage),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateRoute: AppRouter.onGenerateRoute,
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
