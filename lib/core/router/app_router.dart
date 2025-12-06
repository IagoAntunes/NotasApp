import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_app/src/home/presentation/screens/note_stats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/database/keyvalue/app_sharedpreferences_keys.dart';
import '../../core/di/injector.dart';
import '../../src/auh/presentation/container/auth_container.dart';
import '../../src/auh/presentation/container/register_container.dart';
import '../../src/home/domain/models/note_details_params.dart';
import '../../src/home/presentation/container/home_container.dart';
import '../../src/home/presentation/container/note_details_container.dart';
import '../../src/home/presentation/container/note_stats_container.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.auth,
      redirect: (context, state) {
        final prefs = injector<SharedPreferences>();
        var isLogged = prefs.getBool(AppSharedpreferencesKeys.isLogged) ?? false;

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
        GoRoute(
          path: AppRoutes.noteDetails,
          name: 'noteDetails',
          pageBuilder: (context, state) {
            final args = state.extra as NoteDetailsParams;

            return MaterialPage(
              child: NoteDetailsContainer(
                params: args,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.noteStats,
          name: 'noteStats',
          pageBuilder: (context, state) {
            final args = state.extra as NoteStatsData;
            return MaterialPage(
              child: NoteStatsContainer(
                data: args,
              ),
            );
          },
        ),
      ],
    );
  }
}
