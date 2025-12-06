import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/shared/note/infra/datasource/note_data_datasource.dart';
import 'package:notes_app/shared/note/infra/repository/note_data_repository_impl.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class MockNoteDataDatasource extends Mock implements INoteDataDatasource {}

void main() {
  late NoteDataRepositoryImpl repository;
  late MockNoteDataDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockNoteDataDatasource();
    repository = NoteDataRepositoryImpl(datasource: mockDatasource);
  });

  final tNote = NoteModel(
    uid: 'note1',
    text: 'Test Note',
    updatedCount: 0,
    createdAt: 1234567890,
  );
  const tUserId = 'user1';
  final tError = ResultError(message: 'error', code: '400');

  group('NoteDataRepositoryImpl', () {
    group('getNotesByUser', () {
      test('should return List<NoteModel> when datasource returns success', () async {
        when(() => mockDatasource.getNotesByUser(userId: tUserId)).thenAnswer((_) async => Right([
              tNote
            ]));

        final result = await repository.getNotesByUser(userId: tUserId);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) {
            expect(r, isA<List<NoteModel>>());
            expect(r.length, 1);
            expect(r.first, tNote);
          },
        );
        verify(() => mockDatasource.getNotesByUser(userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource returns failure', () async {
        when(() => mockDatasource.getNotesByUser(userId: tUserId)).thenAnswer((_) async => Left(tError));

        final result = await repository.getNotesByUser(userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, tError),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.getNotesByUser(userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource throws exception', () async {
        when(() => mockDatasource.getNotesByUser(userId: tUserId)).thenThrow(Exception('Unexpected error'));

        final result = await repository.getNotesByUser(userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ResultError>()),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.getNotesByUser(userId: tUserId)).called(1);
      });
    });

    group('createNote', () {
      test('should return true when datasource returns success', () async {
        when(() => mockDatasource.createNote(note: tNote, userId: tUserId)).thenAnswer((_) async => Right(true));

        final result = await repository.createNote(note: tNote, userId: tUserId);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r, true),
        );
        verify(() => mockDatasource.createNote(note: tNote, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource returns failure', () async {
        when(() => mockDatasource.createNote(note: tNote, userId: tUserId)).thenAnswer((_) async => Left(tError));

        final result = await repository.createNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, tError),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.createNote(note: tNote, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource throws exception', () async {
        when(() => mockDatasource.createNote(note: tNote, userId: tUserId)).thenThrow(Exception('Unexpected error'));

        final result = await repository.createNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ResultError>()),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.createNote(note: tNote, userId: tUserId)).called(1);
      });
    });

    group('updateNote', () {
      test('should return true when datasource returns success', () async {
        when(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).thenAnswer((_) async => Right(true));

        final result = await repository.updateNote(note: tNote, userId: tUserId);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r, true),
        );
        verify(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource returns failure', () async {
        when(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).thenAnswer((_) async => Left(tError));

        final result = await repository.updateNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, tError),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource throws exception', () async {
        when(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).thenThrow(Exception('Unexpected error'));

        final result = await repository.updateNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ResultError>()),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.updateNote(note: tNote, userId: tUserId)).called(1);
      });
    });

    group('deleteNote', () {
      test('should return true when datasource returns success', () async {
        when(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).thenAnswer((_) async => Right(true));

        final result = await repository.deleteNote(uidNote: tNote.uid, userId: tUserId);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r, true),
        );
        verify(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource returns failure', () async {
        when(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).thenAnswer((_) async => Left(tError));

        final result = await repository.deleteNote(uidNote: tNote.uid, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, tError),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).called(1);
      });

      test('should return ResultError when datasource throws exception', () async {
        when(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).thenThrow(Exception('Unexpected error'));

        final result = await repository.deleteNote(uidNote: tNote.uid, userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ResultError>()),
          (r) => fail('Should be Left'),
        );
        verify(() => mockDatasource.deleteNote(uidNote: tNote.uid, userId: tUserId)).called(1);
      });
    });
  });
}
