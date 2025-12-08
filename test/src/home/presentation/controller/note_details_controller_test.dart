import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/shared/note/domain/repository/note_data_repository.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';
import 'package:notes_app/src/home/presentation/controller/note_details_controller.dart';
import 'package:notes_app/src/home/presentation/states/note_details_state.dart';

class MockNoteDataRepository extends Mock implements INoteDataRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late NoteDetailsController controller;
  late MockNoteDataRepository mockNoteDataRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockNoteDataRepository = MockNoteDataRepository();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    controller = NoteDetailsController(
      noteRepository: mockNoteDataRepository,
      firebaseAuth: mockFirebaseAuth,
    );
    registerFallbackValue(NoteModel(uid: '', text: '', updatedCount: 0, createdAt: 0));
  });

  const tUserId = 'user1';
  final tNote = NoteModel(
    uid: 'note1',
    text: 'Test Note',
    updatedCount: 0,
    createdAt: 1234567890,
  );
  final tError = ResultError(message: 'error message', code: '400');

  group('NoteDetailsController', () {
    test('initial state should be NoteDetailsIdle', () {
      expect(controller.state, isA<NoteDetailsIdle>());
    });

    group('saveNote', () {
      test('should emit [NeedRebuildHomeListener] when success', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.createNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).thenAnswer((_) async => Right(true));

        final future = controller.saveNote(text: 'New Note');

        await future;
        expect(controller.state, isA<NoteDetailsIdle>());
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.createNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).called(1);
      });

      test('should emit [NeedLoginHomeListener] when userId is null', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final future = controller.saveNote(text: 'New Note');

        await future;
        expect(controller.state, isA<NeedLoginHomeListener>());
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verifyNever(() => mockNoteDataRepository.createNote(
              note: any(named: 'note'),
              userId: any(named: 'userId'),
            ));
      });

      test('should emit [NoteDetailsErrorListener] when fails', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.createNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).thenAnswer((_) async => Left(tError));

        final future = controller.saveNote(text: 'New Note');

        await future;
        expect(controller.state, isA<NoteDetailsErrorListener>());
        expect((controller.state as NoteDetailsErrorListener).message, 'error message');
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.createNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).called(1);
      });
    });

    group('updateNote', () {
      test('should emit [NeedRebuildHomeListener] when success', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.updateNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).thenAnswer((_) async => Right(true));

        final future = controller.updateNote(newText: 'Updated Note', note: tNote);

        await future;
        expect(controller.state, isA<NoteDetailsIdle>());
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.updateNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).called(1);
      });

      test('should emit [NeedLoginHomeListener] when userId is null', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final future = controller.updateNote(newText: 'Updated Note', note: tNote);

        await future;
        expect(controller.state, isA<NeedLoginHomeListener>());
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verifyNever(() => mockNoteDataRepository.updateNote(
              note: any(named: 'note'),
              userId: any(named: 'userId'),
            ));
      });

      test('should emit [NoteDetailsErrorListener] when fails', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.updateNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).thenAnswer((_) async => Left(tError));

        final future = controller.updateNote(newText: 'Updated Note', note: tNote);

        await future;
        expect(controller.state, isA<NoteDetailsErrorListener>());
        expect((controller.state as NoteDetailsErrorListener).message, 'error message');
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.updateNote(
              note: any(named: 'note'),
              userId: tUserId,
            )).called(1);
      });
    });

    group('deleteNote', () {
      test('should emit [NeedRebuildHomeListener] when success', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.deleteNote(
              uidNote: tNote.uid,
              userId: tUserId,
            )).thenAnswer((_) async => Right(true));

        final future = controller.deleteNote(uidNote: tNote.uid);

        await future;
        expect(controller.state, isA<NeedRebuildHomeListener>());
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.deleteNote(
              uidNote: tNote.uid,
              userId: tUserId,
            )).called(1);
      });

      test('should emit [NoteDetailsErrorListener] when fails', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockNoteDataRepository.deleteNote(
              uidNote: tNote.uid,
              userId: tUserId,
            )).thenAnswer((_) async => Left(tError));

        final future = controller.deleteNote(uidNote: tNote.uid);

        await future;
        expect(controller.state, isA<NoteDetailsErrorListener>());
        expect((controller.state as NoteDetailsErrorListener).message, 'error message');
        verify(() => mockFirebaseAuth.currentUser).called(1);
        verify(() => mockNoteDataRepository.deleteNote(
              uidNote: tNote.uid,
              userId: tUserId,
            )).called(1);
      });
    });
  });
}
