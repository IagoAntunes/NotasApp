import 'package:flutter/material.dart';
import 'package:notes_app/core/styles/app_note_color.dart';

class NoteStatsScreen extends StatelessWidget {
  final NoteStatsData data;

  const NoteStatsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Cálculo para garantir que a barra maior tenha 100% da altura disponível
    final int maxVal = (data.letters > data.digits) ? data.letters : data.digits;
    final int safeMax = maxVal == 0 ? 1 : maxVal;

    return Scaffold(
      backgroundColor: AppNoteColors.getColor(data.index).base,
      appBar: AppBar(
        title: const Text("Estatísticas", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.error != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red[100],
                child: Text("Erro ao carregar: ${data.error}"),
              ),
            const Text(
              "Visão Geral",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Caracteres",
                    value: data.totalChars.toString(),
                    icon: Icons.text_fields,
                    color: const Color(0xFFE3F2FD),
                    textColor: const Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: "Linhas",
                    value: data.totalLines.toString(),
                    icon: Icons.format_align_justify,
                    color: const Color(0xFFE8F5E9),
                    textColor: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _StatCard(
              title: "Total de Edições",
              value: data.totalEdits.toString(),
              icon: Icons.edit_note,
              color: const Color(0xFFFFF3E0),
              textColor: const Color(0xFFEF6C00),
              isFullWidth: true,
            ),
            const SizedBox(height: 32),
            const Text(
              "Distribuição de Conteúdo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Comparativo: Letras vs Números",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              height: 220,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BarColumn(
                    label: "Letras",
                    value: data.letters,
                    percentage: data.letters / safeMax,
                    color: const Color(0xFFCE93D8),
                  ),
                  Container(width: 1, height: 150, color: Colors.grey.withOpacity(0.2)),
                  _BarColumn(
                    label: "Números",
                    value: data.digits,
                    percentage: data.digits / safeMax,
                    color: const Color(0xFFFFCA28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String label;
  final int value;
  final double percentage;
  final Color color;

  const _BarColumn({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 100 * percentage,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool isFullWidth;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.textColor,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: isFullWidth ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoteStatsData {
  final int totalLines;
  final int totalEdits;
  final int totalChars;
  final int letters;
  final int digits;
  final String? error;
  final int index;

  const NoteStatsData({
    required this.totalLines,
    required this.totalEdits,
    required this.totalChars,
    required this.letters,
    required this.digits,
    required this.index,
    this.error,
  });

  factory NoteStatsData.empty({String? error}) {
    return NoteStatsData(
      totalLines: 0,
      totalEdits: 0,
      totalChars: 0,
      letters: 0,
      digits: 0,
      index: 0,
      error: error,
    );
  }
}
