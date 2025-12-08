// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:notes_app/core/styles/app_note_color.dart';

class NoteDetailScreen extends StatefulWidget {
  final String content;
  final Color backgroundColor;
  final int index;
  final bool isCreating;
  final bool isLoading;
  final ValueChanged<String> onSave;
  final VoidCallback onDelete;
  final Function(double, String) onTapStats;
  final VoidCallback onBack;

  const NoteDetailScreen({
    super.key,
    required this.content,
    required this.backgroundColor,
    required this.index,
    required this.isCreating,
    this.isLoading = false,
    required this.onSave,
    required this.onDelete,
    required this.onTapStats,
    required this.onBack,
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
    if (widget.isCreating) {
      _isEditing = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ignoreInteractions = widget.isLoading;

    return PopScope(
      canPop: !widget.isLoading,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: ignoreInteractions ? null : widget.onBack,
          ),
        ),
        floatingActionButton: widget.isCreating
            ? null
            : FloatingActionButton.extended(
                backgroundColor: AppNoteColors.getColor(widget.index).darker,
                elevation: ignoreInteractions ? 0 : 6,
                label: Text(
                  'Estatísticas',
                  style: TextStyle(
                    color: ignoreInteractions ? Colors.black38 : Colors.black,
                  ),
                ),
                icon: Icon(
                  Icons.bar_chart_outlined,
                  color: ignoreInteractions ? Colors.black38 : Colors.black,
                ),
                onPressed: ignoreInteractions ? null : () => widget.onTapStats(MediaQuery.of(context).size.width - 48, _controller.text),
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
                            disabledBackgroundColor: AppNoteColors.getColor(widget.index).darker.withOpacity(0.5),
                          ),
                          onPressed: ignoreInteractions
                              ? null
                              : () {
                                  if (_isEditing) {
                                    widget.onSave.call(_controller.text);
                                  }
                                  setState(() {
                                    _isEditing = !_isEditing;
                                  });
                                },
                          icon: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : Icon(_isEditing ? Icons.check : Icons.edit_outlined),
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
                              disabledBackgroundColor: AppNoteColors.getColor(widget.index).darker.withOpacity(0.5),
                            ),
                            onPressed: ignoreInteractions ? null : widget.onDelete,
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _isEditing
                        ? TextField(
                            controller: _controller,
                            enabled: !ignoreInteractions,
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
      ),
    );
  }
}
