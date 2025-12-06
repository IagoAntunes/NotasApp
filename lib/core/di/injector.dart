import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_app/shared/userData/domain/repository/user_data_repository.dart';
import 'package:notes_app/shared/userData/external/datasource/datasource/user_data_datasource_impl.dart';
import 'package:notes_app/shared/userData/infra/datasource/user_data_datasource.dart';
import 'package:notes_app/shared/userData/infra/repository/user_data_repository_impl.dart';
import 'package:notes_app/src/auh/domain/repository/auth_repository.dart';
import 'package:notes_app/src/auh/external/datasource/auth_datasource_impl.dart';
import 'package:notes_app/src/auh/infra/datasource/auth_datasource.dart';
import 'package:notes_app/src/auh/infra/repository/auth_repository_impl.dart';
import 'package:notes_app/src/auh/presentation/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/auh/presentation/controller/register_controller.dart';
import '../../src/home/presentation/controller/home_controller.dart';
import '../../src/home/presentation/controller/note_details_controller.dart';

final injector = GetIt.instance;

Future<void> setupInjector() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  injector.registerSingleton<SharedPreferences>(sharedPreferences);
  injector.registerFactory<IAuthDataSource>(
    () => AuthDatasourceImpl(firebaseAuth: firebaseAuth, firestore: firestore),
  );
  injector.registerFactory<IAuthRepository>(
    () => AuthRepositoryImpl(authDataSource: injector(), sharedPreferences: injector()),
  );
  injector.registerFactory<IUserDataDatasource>(
    () => UserDataDatasourceImpl(firestore: firestore),
  );
  injector.registerFactory<IUserDataRepository>(
    () => UserDataRepositoryImpl(datasource: injector()),
  );

  injector.registerLazySingleton<AuthController>(() => AuthController(authRepository: injector()));
  injector.registerLazySingleton<RegisterController>(() => RegisterController(authRepository: injector()));
  injector.registerLazySingleton<HomeController>(() => HomeController(
        authRepository: injector(),
        sharedPreferences: injector(),
        userDataRepository: injector(),
      ));
  injector.registerFactory<NoteDetailsController>(
    () => NoteDetailsController(
      sharedPreferences: injector(),
      userDataRepository: injector(),
    ),
  );
}
