import 'package:flutter/material.dart';
import 'package:notes_app/core/styles/app_note_color.dart';

class NoteDetailScreen extends StatefulWidget {
  final String content;
  final Color backgroundColor;
  final int index;
  final bool isCreating;
  final ValueChanged<String> onSave;
  final VoidCallback onDelete;
  final VoidCallback onTapStats;

  const NoteDetailScreen({
    super.key,
    required this.content,
    required this.backgroundColor,
    required this.index,
    required this.isCreating,
    required this.onSave,
    required this.onDelete,
    required this.onTapStats,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: widget.isCreating
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppNoteColors.getColor(widget.index).darker,
              label: Text('Estatísticas', style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.bar_chart_outlined),
              onPressed: widget.onTapStats,
            ),
      body: SafeArea(
        child: Hero(
          tag: 'note_${widget.index}',
          child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Nota ${widget.index + 1}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppNoteColors.getColor(widget.index).darker,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          if (_isEditing) {
                            widget.onSave.call(_controller.text);
                          }
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                        icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined),
                      ),
                      const SizedBox(width: 8),
                      Visibility(
                        visible: !widget.isCreating,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: AppNoteColors.getColor(widget.index).darker,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: widget.onDelete,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _isEditing
                      ? TextField(
                          controller: _controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite sua nota aqui...',
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        )
                      : Text(
                          _controller.text,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
