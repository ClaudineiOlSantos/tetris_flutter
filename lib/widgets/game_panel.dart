import 'package:flutter/material.dart';

import '../game/tetris_game.dart';

class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.game,
    required this.onPauseToggle,
    required this.onRestart,
  });

  final TetrisGame game;
  final VoidCallback onPauseToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (game.status) {
      GameStatus.ready => 'Pronto',
      GameStatus.playing => 'Jogando',
      GameStatus.paused => 'Pausado',
      GameStatus.gameOver => 'Game over',
    };

    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14211F),
        border: Border.all(color: const Color(0xFF2BB7A8), width: 2),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFFE8FFFA),
          fontSize: 15,
          height: 1.25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'TETRIS',
              style: TextStyle(
                color: Color(0xFF5EEAD4),
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PanelValue(label: 'Nivel', value: '${game.level}'),
                  _PanelValue(label: 'Pontuacao', value: '${game.score}'),
                  _PanelValue(label: 'Linhas', value: '${game.linesCleared}'),
                  _PanelValue(label: 'Estado', value: statusLabel),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2BB7A8),
                foregroundColor: const Color(0xFF071412),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: onPauseToggle,
              child: Text(game.isPaused ? 'Continuar' : 'Pausar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE8FFFA),
                side: const BorderSide(color: Color(0xFF5EEAD4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: onRestart,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelValue extends StatelessWidget {
  const _PanelValue({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2C29),
        border: Border.all(color: const Color(0xFF314A45)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9FB8B2),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFE8FFFA),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

