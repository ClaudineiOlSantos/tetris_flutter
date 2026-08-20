enum TetrominoType {
  i,
  o,
  t,
  s,
  z,
  j,
  l,
}

class CellOffset {
  const CellOffset(this.x, this.y);

  final int x;
  final int y;
}

class Tetromino {
  const Tetromino(this.type);

  final TetrominoType type;

  List<CellOffset> cells(int rotation) {
    final rotations = _shapes[type]!;
    return rotations[rotation % rotations.length];
  }
}

const Map<TetrominoType, List<List<CellOffset>>> _shapes = {
  TetrominoType.i: [
    [
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(3, 1),
    ],
    [
      CellOffset(2, 0),
      CellOffset(2, 1),
      CellOffset(2, 2),
      CellOffset(2, 3),
    ],
  ],
  TetrominoType.o: [
    [
      CellOffset(1, 0),
      CellOffset(2, 0),
      CellOffset(1, 1),
      CellOffset(2, 1),
    ],
  ],
  TetrominoType.t: [
    [
      CellOffset(1, 0),
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
    ],
    [
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(1, 2),
    ],
    [
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(1, 2),
    ],
    [
      CellOffset(1, 0),
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(1, 2),
    ],
  ],
  TetrominoType.s: [
    [
      CellOffset(1, 0),
      CellOffset(2, 0),
      CellOffset(0, 1),
      CellOffset(1, 1),
    ],
    [
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(2, 2),
    ],
  ],
  TetrominoType.z: [
    [
      CellOffset(0, 0),
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(2, 1),
    ],
    [
      CellOffset(2, 0),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(1, 2),
    ],
  ],
  TetrominoType.j: [
    [
      CellOffset(0, 0),
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
    ],
    [
      CellOffset(1, 0),
      CellOffset(2, 0),
      CellOffset(1, 1),
      CellOffset(1, 2),
    ],
    [
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(2, 2),
    ],
    [
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(0, 2),
      CellOffset(1, 2),
    ],
  ],
  TetrominoType.l: [
    [
      CellOffset(2, 0),
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
    ],
    [
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(1, 2),
      CellOffset(2, 2),
    ],
    [
      CellOffset(0, 1),
      CellOffset(1, 1),
      CellOffset(2, 1),
      CellOffset(0, 2),
    ],
    [
      CellOffset(0, 0),
      CellOffset(1, 0),
      CellOffset(1, 1),
      CellOffset(1, 2),
    ],
  ],
};

