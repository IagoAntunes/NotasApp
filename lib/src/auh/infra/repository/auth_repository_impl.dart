import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/services/database/keyvalue/app_sharedpreferences_keys.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';
import 'package:notes_app/src/auh/domain/repository/auth_repository.dart';
import 'package:notes_app/src/auh/infra/datasource/auth_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required IAuthDataSource authDataSource,
    required SharedPreferences sharedPreferences,
  })  : _authDataSource = authDataSource,
        _sharedPreferences = sharedPreferences;

  final IAuthDataSource _authDataSource;
  final SharedPreferences _sharedPreferences;

  @override
  Future<Either<ResultError, UserCredentialModel>> registerWithEmailAndPassword({required String email, required String password}) async {
    final result = await _authDataSource.registerWithEmailAndPassword(email: email, password: password);
    if (result.isRight()) {
      await result.fold(
        (_) {},
        (r) async {
          await _authDataSource.registerUserDatabase(id: r.id, email: r.email);
        },
      );
    }
    return result;
  }

  @override
  Future<Either<ResultError, UserCredentialModel>> signInWithEmailAndPassword({required String email, required String password}) async {
    final result = await _authDataSource.signInWithEmailAndPassword(email: email, password: password);
    if (result.isRight()) {
      _sharedPreferences.setString(AppSharedpreferencesKeys.email, email);
      _sharedPreferences.setBool(AppSharedpreferencesKeys.isLogged, true);
    }
    return result;
  }

  @override
  Future<Either<ResultError, bool>> signOut() async {
    final result = await _authDataSource.signOut();
    if (result.isRight()) {
      _sharedPreferences.remove(AppSharedpreferencesKeys.email);
      _sharedPreferences.setBool(AppSharedpreferencesKeys.isLogged, false);
    }
    return result;
  }
}
