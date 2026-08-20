import 'dart:math';

import 'package:flutter/foundation.dart';

import 'tetromino.dart';

enum GameStatus {
  ready,
  playing,
  paused,
  gameOver,
}

class ActivePiece {
  const ActivePiece({
    required this.tetromino,
    required this.row,
    required this.col,
    required this.rotation,
  });

  final Tetromino tetromino;
  final int row;
  final int col;
  final int rotation;

  ActivePiece copyWith({
    int? row,
    int? col,
    int? rotation,
  }) {
    return ActivePiece(
      tetromino: tetromino,
      row: row ?? this.row,
      col: col ?? this.col,
      rotation: rotation ?? this.rotation,
    );
  }
}

class TetrisGame extends ChangeNotifier {
  TetrisGame({Random? random}) : _random = random ?? Random() {
    reset();
  }

  static const int rows = 20;
  static const int cols = 10;

  final Random _random;

  late List<List<bool>> _board;
  late ActivePiece _currentPiece;

  int _score = 0;
  int _level = 1;
  int _linesCleared = 0;
  GameStatus _status = GameStatus.ready;

  List<List<bool>> get board => _board;
  ActivePiece get currentPiece => _currentPiece;
  int get score => _score;
  int get level => _level;
  int get linesCleared => _linesCleared;
  GameStatus get status => _status;
  bool get isGameOver => _status == GameStatus.gameOver;
  bool get isPaused => _status == GameStatus.paused;

  int get dropIntervalMs {
    return max(120, 700 - ((_level - 1) * 60));
  }

  void reset() {
    _board = List.generate(rows, (_) => List.filled(cols, false));
    _score = 0;
    _level = 1;
    _linesCleared = 0;
    _status = GameStatus.playing;
    _spawnPiece();
    notifyListeners();
  }

  void tick() {
    if (_status != GameStatus.playing) {
      return;
    }

    if (!_moveBy(1, 0)) {
      _lockCurrentPiece();
    }

    notifyListeners();
  }

  void moveLeft() {
    if (_status == GameStatus.playing && _moveBy(0, -1)) {
      notifyListeners();
    }
  }

  void togglePause() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      notifyListeners();
    } else if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
      notifyListeners();
    }
  }

  void moveRight() {
    if (_status == GameStatus.playing && _moveBy(0, 1)) {
      notifyListeners();
    }
  }

  void softDrop() {
    if (_status != GameStatus.playing) {
      return;
    }

    if (!_moveBy(1, 0)) {
      _lockCurrentPiece();
    }

    notifyListeners();
  }

  void hardDrop() {
    if (_status != GameStatus.playing) {
      return;
    }

    while (_moveBy(1, 0)) {}
    _score += 2 * _level;
    _updateLevelFromScore();
    _lockCurrentPiece();
    notifyListeners();
  }

  void rotate() {
    if (_status != GameStatus.playing) {
      return;
    }

    final rotated = _currentPiece.copyWith(
      rotation: _currentPiece.rotation + 1,
    );

    if (_canPlace(rotated)) {
      _currentPiece = rotated;
      notifyListeners();
      return;
    }

    // A tiny wall kick keeps rotations usable near the left and right edges.
    for (final colOffset in const [-1, 1, -2, 2]) {
      final kicked = rotated.copyWith(col: rotated.col + colOffset);
      if (_canPlace(kicked)) {
        _currentPiece = kicked;
        notifyListeners();
        return;
      }
    }
  }

  bool isOccupied(int row, int col) {
    if (_board[row][col]) {
      return true;
    }

    for (final cell in _currentPiece.tetromino.cells(_currentPiece.rotation)) {
      final pieceRow = _currentPiece.row + cell.y;
      final pieceCol = _currentPiece.col + cell.x;
      if (pieceRow == row && pieceCol == col) {
        return true;
      }
    }

    return false;
  }

  bool _moveBy(int rowOffset, int colOffset) {
    final moved = _currentPiece.copyWith(
      row: _currentPiece.row + rowOffset,
      col: _currentPiece.col + colOffset,
    );

    if (!_canPlace(moved)) {
      return false;
    }

    _currentPiece = moved;
    return true;
  }

  void _spawnPiece() {
    final values = TetrominoType.values;
    _currentPiece = ActivePiece(
      tetromino: Tetromino(values[_random.nextInt(values.length)]),
      row: 0,
      col: 3,
      rotation: 0,
    );

    if (!_canPlace(_currentPiece)) {
      _status = GameStatus.gameOver;
    }
  }

  bool _canPlace(ActivePiece piece) {
    for (final cell in piece.tetromino.cells(piece.rotation)) {
      final row = piece.row + cell.y;
      final col = piece.col + cell.x;

      if (col < 0 || col >= cols || row >= rows) {
        return false;
      }

      if (row >= 0 && _board[row][col]) {
        return false;
      }
    }

    return true;
  }

  void _lockCurrentPiece() {
    for (final cell in _currentPiece.tetromino.cells(_currentPiece.rotation)) {
      final row = _currentPiece.row + cell.y;
      final col = _currentPiece.col + cell.x;

      if (row >= 0 && row < rows && col >= 0 && col < cols) {
        _board[row][col] = true;
      }
    }

    final clearedNow = _clearCompletedLines();
    if (clearedNow > 0) {
      _score += _scoreFor(clearedNow);
      _linesCleared += clearedNow;
      _updateLevelFromScore();
    }

    _spawnPiece();
  }

  int _clearCompletedLines() {
    final remainingRows = _board.where((row) {
      return row.any((cell) => !cell);
    }).toList();

    final cleared = rows - remainingRows.length;
    if (cleared == 0) {
      return 0;
    }

    final emptyRows = List.generate(
      cleared,
      (_) => List.filled(cols, false),
    );
    _board = [...emptyRows, ...remainingRows];
    return cleared;
  }

  void _updateLevelFromScore() {
    _level = (_score ~/ 1000) + 1;
  }

  int _scoreFor(int clearedLines) {
    switch (clearedLines) {
      case 1:
        return 100 * _level;
      case 2:
        return 300 * _level;
      case 3:
        return 500 * _level;
      case 4:
        return 800 * _level;
      default:
        return 0;
    }
  }
}
