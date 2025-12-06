import 'package:flutter/material.dart';

class NoteDetailScreen extends StatefulWidget {
  final String title;
  final String content;
  final Color backgroundColor;
  final int index;
  final bool isCreating;
  final ValueChanged<String> onSave;
  final VoidCallback onDelete;

  const NoteDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.index,
    required this.isCreating,
    required this.onSave,
    required this.onDelete,
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
                        widget.title,
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
                          backgroundColor: Colors.white70,
                          foregroundColor: Colors.black87,
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
                            backgroundColor: Colors.white70,
                            foregroundColor: Colors.black87,
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
