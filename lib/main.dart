import 'package:flutter/material.dart';
import 'package:notes_app/core/styles/app_colors.dart';
import 'package:notes_app/core/di/injector.dart';

import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.create();

    return MaterialApp.router(
      title: 'Target Sistemas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      routerConfig: router,
    );
  }
}
