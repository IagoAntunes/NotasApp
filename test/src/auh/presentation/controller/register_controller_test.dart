import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';
import 'package:notes_app/src/auh/domain/repository/auth_repository.dart';
import 'package:notes_app/src/auh/presentation/controller/register_controller.dart';
import 'package:notes_app/src/auh/presentation/states/register_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterController controller;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    controller = RegisterController(authRepository: mockAuthRepository);
  });

  final tUserCredential = UserCredentialModel(id: '123', email: 'test@test.com');
  final tError = ResultError(message: 'error message', code: '400');

  group('RegisterController', () {
    test('initial state should be RegisterIdle', () {
      expect(controller.state, isA<RegisterIdle>());
    });

    group('register', () {
      test('should emit [RegisterLoading, RegisterSuccessListener] when success', () async {
        when(() => mockAuthRepository.registerWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUserCredential));

        final future = controller.register('test@test.com', 'password');

        expect(controller.state, isA<RegisterLoading>());
        await future;
        expect(controller.state, isA<RegisterSuccessListener>());
        verify(() => mockAuthRepository.registerWithEmailAndPassword(
              email: 'test@test.com',
              password: 'password',
            )).called(1);
      });

      test('should emit [RegisterLoading, RegisterErrorListener] when fails', () async {
        when(() => mockAuthRepository.registerWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Left(tError));

        final future = controller.register('test@test.com', 'password');

        expect(controller.state, isA<RegisterLoading>());
        await future;
        expect(controller.state, isA<RegisterErrorListener>());
        verify(() => mockAuthRepository.registerWithEmailAndPassword(
              email: 'test@test.com',
              password: 'password',
            )).called(1);
      });
    });

    test('resetState should set state to RegisterIdle', () {
      controller.state = RegisterLoading();

      controller.resetState();

      expect(controller.state, isA<RegisterIdle>());
    });
  });
}
