import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';
import 'package:notes_app/src/auh/domain/repository/auth_repository.dart';
import 'package:notes_app/src/auh/presentation/controller/auth_controller.dart';
import 'package:notes_app/src/auh/presentation/states/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late AuthController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = AuthController(authRepository: mockAuthRepository);
  });

  final tUserCredential = UserCredentialModel(id: '123', email: 'test@test.com');
  final tError = ResultError(message: 'error', code: '400');

  group('AuthController', () {
    test('initial state should be AuthIdle', () {
      expect(controller.state, isA<AuthIdle>());
    });

    group('login', () {
      test('should emit [AuthLoading, AuthSuccessLoginListener] when success', () async {
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUserCredential));

        final future = controller.login('test@test.com', 'password');

        expect(controller.state, isA<AuthLoading>());
        await future;
        expect(controller.state, isA<AuthSuccessLoginListener>());
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'test@test.com',
              password: 'password',
            )).called(1);
      });

      test('should emit [AuthLoading, AuthErrorListener] when fails', () async {
        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(tError));

        final future = controller.login('test@test.com', 'password');

        expect(controller.state, isA<AuthLoading>());
        await future;
        expect(controller.state, isA<AuthErrorListener>());
        expect((controller.state as AuthErrorListener).message, '400');
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
              email: 'test@test.com',
              password: 'password',
            )).called(1);
      });
    });

    test('resetState should set state to AuthIdle', () {
      controller.state = AuthLoading();

      controller.resetState();

      expect(controller.state, isA<AuthIdle>());
    });
  });
}
