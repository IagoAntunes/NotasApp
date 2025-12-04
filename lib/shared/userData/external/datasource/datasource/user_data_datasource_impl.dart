import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/services/database/firestore/app_firestore_collection_keys.dart';
import 'package:notes_app/shared/userData/infra/datasource/user_data_datasource.dart';
import 'package:notes_app/src/home/domain/models/note_model.dart';

class UserDataDatasourceImpl implements IUserDataDatasource {
  UserDataDatasourceImpl({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<Either<ResultError, List<NoteModel>>> getNotesByUser({required String userId}) async {
    try {
      final result = await _firestore.collection(AppFirestoreCollectionKeys.users).doc(userId).get();

      final notesData = result.data()?['notes'] as List<dynamic>?;

      return Right([]);
    } catch (e) {
      return Left(ResultError(message: e.toString(), code: ''));
    }
  }
}
