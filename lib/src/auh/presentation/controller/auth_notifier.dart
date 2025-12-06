import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final SharedPreferences _sharedPreferences;

  bool _isLogged = false;
  bool get isLogged => _isLogged;

  AuthNotifier({required FirebaseAuth firebaseAuth, required SharedPreferences sharedPreferences})
      : _firebaseAuth = firebaseAuth,
        _sharedPreferences = sharedPreferences {
    _init();
  }

  void _init() {
    _isLogged = _firebaseAuth.currentUser != null;

    _firebaseAuth.authStateChanges().listen((User? user) {
      final bool loggedIn = user != null;
      if (_isLogged != loggedIn) {
        _isLogged = loggedIn;
        notifyListeners();
      }
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _sharedPreferences.clear();
  }
}
