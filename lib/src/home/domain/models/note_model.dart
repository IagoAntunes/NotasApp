import 'dart:convert';

class NoteModel {
  final String uid;
  final String text;
  final int updatedCount;
  final int createdAt;

  NoteModel({
    required this.uid,
    required this.text,
    required this.updatedCount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
      'updatedCount': updatedCount,
      'createdAt': createdAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      uid: map['uid'] as String,
      text: map['text'] as String,
      updatedCount: map['updatedCount'] is int ? map['updatedCount'] as int : int.tryParse('${map['updatedCount']}') ?? 0,
      createdAt: map['createdAt'] is int ? map['createdAt'] as int : int.tryParse('${map['createdAt']}') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) => NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
