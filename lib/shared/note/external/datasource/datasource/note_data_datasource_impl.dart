import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/services/database/firestore/app_firestore_collection_keys.dart';
import 'package:notes_app/shared/note/infra/datasource/note_data_datasource.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class NoteDataDatasourceImpl implements INoteDataDatasource {
  NoteDataDatasourceImpl({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId}) async {
    try {
      final query = _firestore.collection(AppFirestoreCollectionKeys.users).doc(userId).collection(AppFirestoreCollectionKeys.notes).orderBy(
            'createdAt',
            descending: false,
          );

      QuerySnapshot<Map<String, dynamic>> result;

      try {
        result = await query.get(const GetOptions(source: Source.server));
      } catch (_) {
        result = await query.get(const GetOptions(source: Source.cache));
      }

      List<NoteModel> notes = [];
      for (var doc in result.docs) {
        notes.add(NoteModel.fromMap(doc.data()));
      }

      return Right(notes);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> createNote({required NoteModel note, required String userId}) async {
    try {
      final docRef = _firestore.collection(AppFirestoreCollectionKeys.users).doc(userId).collection(AppFirestoreCollectionKeys.notes).doc(note.uid);

      await docRef.set(note.toMap()).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return;
        },
      );

      return Right(true);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> updateNote({required NoteModel note, required String userId}) async {
    try {
      final docRef = _firestore.collection(AppFirestoreCollectionKeys.users).doc(userId).collection(AppFirestoreCollectionKeys.notes).doc(note.uid);

      await docRef.update(note.toMap()).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return;
        },
      );

      return Right(true);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }

  @override
  Future<Either<ResultError, bool>> deleteNote({required String uidNote, required String userId}) async {
    try {
      final docRef = _firestore.collection(AppFirestoreCollectionKeys.users).doc(userId).collection(AppFirestoreCollectionKeys.notes).doc(uidNote);

      await docRef.delete().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          return;
        },
      );

      return Right(true);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }
}
