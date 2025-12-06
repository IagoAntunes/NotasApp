// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_app/core/utils/result_error.dart';
import 'package:notes_app/src/auh/domain/models/user_credential_model.dart';
import 'package:notes_app/src/auh/external/datasource/auth_datasource_impl.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late AuthDatasourceImpl datasource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    datasource = AuthDatasourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthDatasourceImpl', () {
    const tEmail = 'admin@gmail.com';
    const tPassword = 'admin123';
    const tUserId = '12345';

    group('registerWithEmailAndPassword', () {
      test('should return UserCredentialModel when registration is successful', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockUser.email).thenReturn(tEmail);

        final result = await datasource.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) {
            expect(r, isA<UserCredentialModel>());
            expect(r.id, tUserId);
            expect(r.email, tEmail);
          },
        );
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).called(1);
      });

      test('should return ResultError when FirebaseAuthException occurs', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'email-already-in-use', message: 'Email exists'));

        final result = await datasource.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'email-already-in-use');
            expect(l.message, 'Email exists');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('should return ResultError when generic Exception occurs', () async {
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(Exception('Generic error'));

        final result = await datasource.registerWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'unknown');
            expect(l.message, 'Ocorreu um erro inesperado.');
          },
          (r) => fail('Should be Left'),
        );
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should return UserCredentialModel when sign in is successful', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tUserId);
        when(() => mockUser.email).thenReturn(tEmail);

        final result = await datasource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) {
            expect(r, isA<UserCredentialModel>());
            expect(r.id, tUserId);
            expect(r.email, tEmail);
          },
        );
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).called(1);
      });

      test('should return ResultError when FirebaseAuthException occurs', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'User not found'));

        final result = await datasource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'user-not-found');
            expect(l.message, 'User not found');
          },
          (r) => fail('Should be Left'),
        );
      });

      test('should return ResultError when generic Exception occurs', () async {
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).thenThrow(Exception('Generic error'));

        final result = await datasource.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'unknown');
            expect(l.message, 'Ocorreu um erro inesperado.');
          },
          (r) => fail('Should be Left'),
        );
      });
    });

    group('registerUserDatabase', () {
      test('should return true when database registration is successful', () async {
        when(() => mockFirestore.collection(any())).thenReturn(mockCollectionReference);
        when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
        when(() => mockDocumentReference.set(any())).thenAnswer((_) async => {});

        final result = await datasource.registerUserDatabase(
          id: tUserId,
          email: tEmail,
        );

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r, true),
        );
        verify(() => mockFirestore.collection('users')).called(1);
        verify(() => mockCollectionReference.doc(tUserId)).called(1);
        verify(() => mockDocumentReference.set(any())).called(1);
      });

      test('should return ResultError when an exception occurs', () async {
        when(() => mockFirestore.collection(any())).thenThrow(Exception('Database error'));

        final result = await datasource.registerUserDatabase(
          id: tUserId,
          email: tEmail,
        );

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'unknown');
            expect(l.message, 'Ocorreu um erro inesperado.');
          },
          (r) => fail('Should be Left'),
        );
      });
    });

    group('signOut', () {
      test('should return true when sign out is successful', () async {
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

        final result = await datasource.signOut();

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should be Right'),
          (r) => expect(r, true),
        );
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should return ResultError when an exception occurs', () async {
        when(() => mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out error'));

        final result = await datasource.signOut();

        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l, isA<ResultError>());
            expect(l.code, 'unknown');
            expect(l.message, 'Ocorreu um erro inesperado.');
          },
          (r) => fail('Should be Left'),
        );
      });
    });
  });
}
