import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/services/database/keyvalue/app_sharedpreferences_keys.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import 'package:notes_app/src/auh/domain/repository/auth_repository.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';
import 'package:notes_app/src/home/presentation/controller/home_controller.dart';
import 'package:notes_app/src/home/presentation/states/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockNoteDataRepository extends Mock implements INoteDataRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late HomeController controller;
  late MockAuthRepository mockAuthRepository;
  late MockNoteDataRepository mockNoteDataRepository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockNoteDataRepository = MockNoteDataRepository();
    mockSharedPreferences = MockSharedPreferences();
    controller = HomeController(
      authRepository: mockAuthRepository,
      userDataRepository: mockNoteDataRepository,
      sharedPreferences: mockSharedPreferences,
    );
  });

  final tNote = NoteModel(
    uid: 'note1',
    text: 'Test Note',
    updatedCount: 0,
    createdAt: 1234567890,
  );
  const tUserId = 'user1';
  final tError = ResultError(message: 'error message', code: '400');

  group('HomeController', () {
    test('initial state should be HomeIdle', () {
      expect(controller.state, isA<HomeIdle>());
    });

    group('fetchNotes', () {
      test('should emit [HomeLoading, HomeComplete] when success', () async {
        when(() => mockSharedPreferences.getString(AppSharedpreferencesKeys.userId)).thenReturn(tUserId);
        when(() => mockNoteDataRepository.getNotesByUser(userId: tUserId)).thenAnswer((_) async => Right([
              tNote
            ]));

        final future = controller.fetchNotes();

        expect(controller.state, isA<HomeLoading>());
        await future;
        expect(controller.state, isA<HomeComplete>());
        expect((controller.state as HomeComplete).notes, [
          tNote
        ]);
        verify(() => mockSharedPreferences.getString(AppSharedpreferencesKeys.userId)).called(1);
        verify(() => mockNoteDataRepository.getNotesByUser(userId: tUserId)).called(1);
      });

      test('should emit [HomeLoading, HomeErrorListener] when fails', () async {
        when(() => mockSharedPreferences.getString(AppSharedpreferencesKeys.userId)).thenReturn(tUserId);
        when(() => mockNoteDataRepository.getNotesByUser(userId: tUserId)).thenAnswer((_) async => Left(tError));

        final future = controller.fetchNotes();

        expect(controller.state, isA<HomeLoading>());
        await future;
        expect(controller.state, isA<HomeErrorListener>());
        expect((controller.state as HomeErrorListener).message, 'error message');
        verify(() => mockSharedPreferences.getString(AppSharedpreferencesKeys.userId)).called(1);
        verify(() => mockNoteDataRepository.getNotesByUser(userId: tUserId)).called(1);
      });
    });

    group('logOut', () {
      test('should emit [HomeLogoutSuccessListener] when success', () async {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async => Right(true));

        final future = controller.logOut();

        await future;
        expect(controller.state, isA<HomeLogoutSuccessListener>());
        verify(() => mockAuthRepository.signOut()).called(1);
      });

      test('should emit [HomeErrorListener] when fails', () async {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async => Left(tError));

        final future = controller.logOut();

        await future;
        expect(controller.state, isA<HomeErrorListener>());
        expect((controller.state as HomeErrorListener).message, 'error message');
        verify(() => mockAuthRepository.signOut()).called(1);
      });
    });

    test('resetState should set state to HomeIdle', () {
      controller.state = HomeLoading();

      controller.resetState();

      expect(controller.state, isA<HomeIdle>());
    });
  });
}
