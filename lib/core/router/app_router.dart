import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/auh/presentation/container/auth_container.dart';
import '../../src/auh/presentation/container/register_container.dart';
import 'routes.dart';

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: AppRoutes.auth,
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
      ],
    );
  }
}
