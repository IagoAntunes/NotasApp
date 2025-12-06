import 'package:flutter/material.dart';

class NoteColor {
  final Color base;
  final Color darker;

  const NoteColor({
    required this.base,
    required this.darker,
  });
}

class AppNoteColors {
  static const List<NoteColor> colors = [
    NoteColor(
      base: Color(0xFFE3F2FD),
      darker: Color(0xFF90CAF9),
    ),
    NoteColor(
      base: Color(0xFFFFEBEE),
      darker: Color(0xFFEF9A9A),
    ),
    NoteColor(
      base: Color(0xFFE8F5E9),
      darker: Color(0xFFA5D6A7),
    ),
    NoteColor(
      base: Color(0xFFFFECB3),
      darker: Color(0xFFFFCA28),
    ),
    NoteColor(
      base: Color(0xFFF3E5F5),
      darker: Color(0xFFCE93D8),
    ),
    NoteColor(
      base: Color(0xFFFFFDE7),
      darker: Color(0xFFFFF59D),
    ),
  ];

  static NoteColor getColor(int index) {
    return colors[index % colors.length];
  }
}
