import 'dart:convert';

import 'package:notes_app/src/home/domain/models/note_model.dart';

class UserModel {
  final String email;
  final List<NoteModel> notes;

  UserModel({
    required this.email,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      notes: List<NoteModel>.from(
        (map['notes'] as List<int>).map<NoteModel>(
          (x) => NoteModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
