import 'package:get_it/get_it.dart';
import 'package:notes_app/src/auh/presentation/controller/auth_controller.dart';

import '../../src/auh/presentation/controller/register_controller.dart';

final injector = GetIt.instance;

Future<void> setupInjector() async {
  injector.registerLazySingleton<AuthController>(() => AuthController());
  injector.registerLazySingleton<RegisterController>(() => RegisterController());
}
