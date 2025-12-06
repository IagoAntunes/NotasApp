import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/services/database/keyvalue/app_sharedpreferences_keys.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';
import 'package:notes_app/src/auh/infra/datasource/auth_datasource.dart';
import 'package:notes_app/src/auh/infra/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthDataSource extends Mock implements IAuthDataSource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDataSource mockAuthDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    mockSharedPreferences = MockSharedPreferences();
    repository = AuthRepositoryImpl(
      authDataSource: mockAuthDataSource,
      sharedPreferences: mockSharedPreferences,
    );
  });

  final tUserCredential = UserCredentialModel(id: '123', email: 'admin@gmail.com');
  final tError = ResultError(message: 'error', code: '400');

  group('AuthRepositoryImpl', () {
    group('registerWithEmailAndPassword', () {
      test('should call datasource register and registerUserDatabase when success', () async {
        when(() => mockAuthDataSource.registerWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUserCredential));
        when(() => mockAuthDataSource.registerUserDatabase(
              id: any(named: 'id'),
              email: any(named: 'email'),
            )).thenAnswer((_) async => Right(true));

        final result = await repository.registerWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'password',
        );

        expect(result.isRight(), true);
        verify(() => mockAuthDataSource.registerWithEmailAndPassword(
              email: 'admin@gmail.com',
              password: 'password',
            )).called(1);
        verify(() => mockAuthDataSource.registerUserDatabase(
              id: '123',
              email: 'admin@gmail.com',
            )).called(1);
      });

      test('should not call registerUserDatabase when register fails', () async {
        when(() => mockAuthDataSource.registerWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(tError));

        final result = await repository.registerWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'password',
        );

        expect(result.isLeft(), true);
        verify(() => mockAuthDataSource.registerWithEmailAndPassword(
              email: 'admin@gmail.com',
              password: 'password',
            )).called(1);
        verifyNever(() => mockAuthDataSource.registerUserDatabase(
              id: any(named: 'id'),
              email: any(named: 'email'),
            ));
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should save data to shared preferences when success', () async {
        when(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUserCredential));
        when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
        when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);

        final result = await repository.signInWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'password',
        );

        expect(result.isRight(), true);
        verify(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: 'admin@gmail.com',
              password: 'password',
            )).called(1);
        verify(() => mockSharedPreferences.setString(AppSharedpreferencesKeys.email, 'admin@gmail.com')).called(1);
        verify(() => mockSharedPreferences.setBool(AppSharedpreferencesKeys.isLogged, true)).called(1);
        verify(() => mockSharedPreferences.setString(AppSharedpreferencesKeys.userId, '123')).called(1);
      });

      test('should not save data to shared preferences when fails', () async {
        when(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(tError));

        final result = await repository.signInWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'password',
        );

        expect(result.isLeft(), true);
        verify(() => mockAuthDataSource.signInWithEmailAndPassword(
              email: 'admin@gmail.com',
              password: 'password',
            )).called(1);
        verifyNever(() => mockSharedPreferences.setString(any(), any()));
        verifyNever(() => mockSharedPreferences.setBool(any(), any()));
      });
    });

    group('signOut', () {
      test('should clear shared preferences when success', () async {
        when(() => mockAuthDataSource.signOut()).thenAnswer((_) async => Right(true));
        when(() => mockSharedPreferences.remove(any())).thenAnswer((_) async => true);
        when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer((_) async => true);

        final result = await repository.signOut();

        expect(result.isRight(), true);
        verify(() => mockAuthDataSource.signOut()).called(1);
        verify(() => mockSharedPreferences.remove(AppSharedpreferencesKeys.email)).called(1);
        verify(() => mockSharedPreferences.setBool(AppSharedpreferencesKeys.isLogged, false)).called(1);
      });

      test('should not clear shared preferences when fails', () async {
        when(() => mockAuthDataSource.signOut()).thenAnswer((_) async => Left(tError));

        final result = await repository.signOut();

        expect(result.isLeft(), true);
        verify(() => mockAuthDataSource.signOut()).called(1);
        verifyNever(() => mockSharedPreferences.remove(any()));
        verifyNever(() => mockSharedPreferences.setBool(any(), any()));
      });
    });
  });
}
