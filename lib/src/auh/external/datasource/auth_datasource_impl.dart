import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/auh/infra/datasource/auth_datasource.dart';

import '../../../../services/database/firestore/app_firestore_collection_keys.dart';
import '../../domain/models/user_credential_model.dart';

class AuthDatasourceImpl implements IAuthDataSource {
  AuthDatasourceImpl({
    required final FirebaseAuth firebaseAuth,
    required final FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<Either<ResultError, UserCredentialModel>> registerWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final UserCredentialModel userCredentialModel = UserCredentialModel(
        id: userCredential.user?.uid ?? '',
        email: userCredential.user?.email ?? '',
      );

      return Right(userCredentialModel);
    } on FirebaseAuthException catch (e) {
      return Left(ResultError(code: e.code, message: e.message ?? 'Ocorreu um erro inesperado.'));
    } catch (e) {
      return Left(ResultError(code: 'unknown', message: 'Ocorreu um erro inesperado.'));
    }
  }

  @override
  Future<Either<ResultError, UserCredentialModel>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      final UserCredentialModel userCredentialModel = UserCredentialModel(
        id: userCredential.user?.uid ?? '',
        email: userCredential.user?.email ?? '',
      );

      return Right(userCredentialModel);
    } on FirebaseAuthException catch (e) {
      return Left(ResultError(code: e.code, message: e.message ?? 'Ocorreu um erro inesperado.'));
    } catch (e) {
      return Left(ResultError(code: 'unknown', message: 'Ocorreu um erro inesperado.'));
    }
  }

  @override
  Future<Either<ResultError, bool>> registerUserDatabase({required String id, required String email}) {
    try {
      final userDoc = _firestore.collection(AppFirestoreCollectionKeys.users).doc(id);
      userDoc.set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return Future.value(Right(true));
    } catch (e) {
      return Future.value(Left(ResultError(code: 'unknown', message: 'Ocorreu um erro inesperado.')));
    }
  }

  @override
  Future<Either<ResultError, bool>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Future.value(Right(true));
    } catch (e) {
      return Future.value(Left(ResultError(code: 'unknown', message: 'Ocorreu um erro inesperado.')));
    }
  }
}
