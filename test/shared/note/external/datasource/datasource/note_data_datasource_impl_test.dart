// ignore_for_file: subtype_of_sealed_class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/shared/note/external/datasource/datasource/note_data_datasource_impl.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

void main() {
  late NoteDataDatasourceImpl datasource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockQuery mockQuery;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockQuery = MockQuery();

    datasource = NoteDataDatasourceImpl(firestore: mockFirestore);

    when(() => mockFirestore.collection(any())).thenReturn(mockCollectionReference);
    when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
    when(() => mockDocumentReference.collection(any())).thenReturn(mockCollectionReference);
  });

  final tNote = NoteModel(
    uid: 'note1',
    text: 'Test Note',
    updatedCount: 0,
    createdAt: 1234567890,
  );
  const tUserId = 'user1';

  group('NoteDataDatasourceImpl', () {
    group('getNotesByUser', () {
      test('should return List<NoteModel> from SERVER when connection is available', () async {
        when(() => mockCollectionReference.orderBy(any(), descending: any(named: 'descending'))).thenReturn(mockQuery);
        when(() => mockQuery.get(const GetOptions(source: Source.server))).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([
          mockQueryDocumentSnapshot
        ]);
        when(() => mockQueryDocumentSnapshot.data()).thenReturn(tNote.toMap());

        final result = await datasource.getNotesByUser(userId: tUserId);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) {
            expect(r, isA<List<NoteModel>>());
            expect(r.length, 1);
            expect(r.first.uid, tNote.uid);
          },
        );

        verify(() => mockQuery.get(const GetOptions(source: Source.server))).called(1);
        verifyNever(() => mockQuery.get(const GetOptions(source: Source.cache)));
      });

      test('should return List<NoteModel> from CACHE when server fails (offline)', () async {
        when(() => mockCollectionReference.orderBy(any(), descending: any(named: 'descending'))).thenReturn(mockQuery);
        when(() => mockQuery.get(const GetOptions(source: Source.server))).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));
        when(() => mockQuery.get(const GetOptions(source: Source.cache))).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockQuerySnapshot.docs).thenReturn([
          mockQueryDocumentSnapshot
        ]);
        when(() => mockQueryDocumentSnapshot.data()).thenReturn(tNote.toMap());

        final result = await datasource.getNotesByUser(userId: tUserId);

        expect(result.isRight(), true);
        verify(() => mockQuery.get(const GetOptions(source: Source.server))).called(1);
        verify(() => mockQuery.get(const GetOptions(source: Source.cache))).called(1);
      });

      test('should return ResultError when BOTH server and cache fail', () async {
        when(() => mockCollectionReference.orderBy(any(), descending: any(named: 'descending'))).thenReturn(mockQuery);
        when(() => mockQuery.get(const GetOptions(source: Source.server))).thenThrow(Exception('Server error'));
        when(() => mockQuery.get(const GetOptions(source: Source.cache))).thenThrow(Exception('Cache error'));

        final result = await datasource.getNotesByUser(userId: tUserId);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ResultError>()),
          (r) => fail('Should be Left'),
        );
      });
    });

    group('createNote', () {
      test('should return true when success (handles timeout logic internally)', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any())).thenAnswer((_) async => {});
        final result = await datasource.createNote(note: tNote, userId: tUserId);

        expect(result.isRight(), true);
        verify(() => mockDocumentReference.set(tNote.toMap())).called(1);
      });

      test('should return ResultError when set throws an exception immediately', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any())).thenThrow(Exception('Firestore error'));

        final result = await datasource.createNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
      });
    });

    group('updateNote', () {
      test('should return true when success', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.update(any())).thenAnswer((_) async => {});

        final result = await datasource.updateNote(note: tNote, userId: tUserId);

        expect(result.isRight(), true);
        verify(() => mockDocumentReference.update(tNote.toMap())).called(1);
      });

      test('should return ResultError when fails', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.update(any())).thenThrow(Exception('Firestore error'));

        final result = await datasource.updateNote(note: tNote, userId: tUserId);

        expect(result.isLeft(), true);
      });
    });

    group('deleteNote', () {
      test('should return true when success', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.delete()).thenAnswer((_) async => {});

        final result = await datasource.deleteNote(uidNote: tNote.uid, userId: tUserId);

        expect(result.isRight(), true);
        verify(() => mockDocumentReference.delete()).called(1);
      });

      test('should return ResultError when fails', () async {
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.delete()).thenThrow(Exception('Firestore error'));

        final result = await datasource.deleteNote(uidNote: tNote.uid, userId: tUserId);

        expect(result.isLeft(), true);
      });
    });
  });
}
