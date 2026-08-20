import 'package:flutter/material.dart';

import '../game/tetris_game.dart';

class TetrisBoard extends StatelessWidget {
  const TetrisBoard({
    super.key,
    required this.game,
  });

  final TetrisGame game;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: TetrisGame.cols / TetrisGame.rows,
      child: CustomPaint(
        painter: _TetrisBoardPainter(game),
      ),
    );
  }
}

class _TetrisBoardPainter extends CustomPainter {
  const _TetrisBoardPainter(this.game);

  static const Color boardColor = Color(0xFFF8FAF7);
  static const Color gridColor = Color(0xFFD5E0DC);
  static const Color brickColor = Color(0xFFD96522);
  static const Color brickHighlight = Color(0xFFF08B3F);
  static const Color brickShadow = Color(0xFF9E3F13);

  final TetrisGame game;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / TetrisGame.cols;
    final boardPaint = Paint()..color = boardColor;
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, boardPaint);

    for (var row = 0; row < TetrisGame.rows; row++) {
      for (var col = 0; col < TetrisGame.cols; col++) {
        final rect = Rect.fromLTWH(
          col * cellSize,
          row * cellSize,
          cellSize,
          cellSize,
        );

        canvas.drawRect(rect, gridPaint..style = PaintingStyle.stroke);

        if (game.isOccupied(row, col)) {
          _drawBrick(canvas, rect.deflate(2));
        }
      }
    }
  }

  void _drawBrick(Canvas canvas, Rect rect) {
    final bodyPaint = Paint()..color = brickColor;
    final highlightPaint = Paint()..color = brickHighlight;
    final shadowPaint = Paint()..color = brickShadow;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      bodyPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top, rect.width, 3),
      highlightPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.bottom - 3, rect.width, 3),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TetrisBoardPainter oldDelegate) {
    return true;
  }
}
