import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/database/keyvalue/app_sharedpreferences_keys.dart';
import '../../core/di/injector.dart';
import '../../src/auh/presentation/container/auth_container.dart';
import '../../src/auh/presentation/container/register_container.dart';
import '../../src/home/presentation/container/home_container.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.auth,
      redirect: (context, state) {
        final prefs = injector<SharedPreferences>();
        final isLogged = prefs.getBool(AppSharedpreferencesKeys.isLogged) ?? false;

        final goingToAuth = state.matchedLocation == AppRoutes.auth || state.matchedLocation == AppRoutes.register;

        if (!isLogged && !goingToAuth) {
          return AppRoutes.auth;
        }
        if (isLogged && goingToAuth) {
          return AppRoutes.home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.auth,
          name: 'auth',
          pageBuilder: (context, state) => const MaterialPage(
            child: AuthContainer(),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          pageBuilder: (context, state) => const MaterialPage(
            child: RegisterContainer(),
          ),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) => const MaterialPage(
            child: HomeContainer(),
          ),
        ),
      ],
    );
  }
}
