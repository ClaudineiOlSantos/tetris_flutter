import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_flutter/game/tetris_game.dart';

void main() {
  test('starts with a playable empty board', () {
    final game = TetrisGame(random: Random(1));

    expect(game.status, GameStatus.playing);
    expect(game.score, 0);
    expect(game.level, 1);
    expect(game.linesCleared, 0);
    expect(game.board.expand((row) => row).every((cell) => !cell), isTrue);
  });

  test('keeps the piece inside the board while moving', () {
    final game = TetrisGame(random: Random(1));

    for (var i = 0; i < TetrisGame.cols * 2; i++) {
      game.moveLeft();
    }
    expect(game.currentPiece.col, greaterThanOrEqualTo(0));

    for (var i = 0; i < TetrisGame.cols * 2; i++) {
      game.moveRight();
    }
    final maxCellX = game.currentPiece.tetromino
        .cells(game.currentPiece.rotation)
        .map((cell) => cell.x)
        .fold(0, (currentMax, x) => max(currentMax, x));
    expect(game.currentPiece.col + maxCellX, lessThan(TetrisGame.cols));
  });

  test('pauses and resumes without moving the piece', () {
    final game = TetrisGame(random: Random(1));
    final initialPiece = game.currentPiece;

    game.togglePause();
    game.tick();
    expect(game.status, GameStatus.paused);
    expect(game.currentPiece.row, initialPiece.row);

    game.togglePause();
    expect(game.status, GameStatus.playing);
  });

  test('hard drop locks a piece and awards drop points', () {
    final game = TetrisGame(random: Random(1));

    game.hardDrop();

    expect(game.score, greaterThan(0));
    expect(game.status, GameStatus.playing);
  });

  test('clears a completed row and updates line statistics', () {
    final game = TetrisGame(random: Random(1));
    for (var col = 0; col < TetrisGame.cols; col++) {
      game.board[TetrisGame.rows - 1][col] = true;
    }

    game.hardDrop();

    expect(game.linesCleared, 1);
    expect(game.score, greaterThan(100));
  });
}

