import 'dart:convert';

class NoteModel {
  final String uid;
  final String text;

  NoteModel({
    required this.uid,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      uid: map['uid'] as String,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) => NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
