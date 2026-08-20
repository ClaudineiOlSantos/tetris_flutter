import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/tetris_game.dart';
import 'widgets/game_panel.dart';
import 'widgets/mobile_controls.dart';
import 'widgets/tetris_board.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tetris Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2BB7A8),
        ),
        scaffoldBackgroundColor: const Color(0xFFE1E8E5),
        useMaterial3: true,
      ),
      home: const TetrisScreen(),
    );
  }
}

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> {
  late final TetrisGame _game;
  late final FocusNode _focusNode;
  Timer? _timer;
  Timer? _autoRestartTimer;
  DateTime _lastDrop = DateTime.now();

  @override
  void initState() {
    super.initState();
    _game = TetrisGame()..addListener(_onGameChanged);
    _focusNode = FocusNode();
    _timer = Timer.periodic(const Duration(milliseconds: 50), _onFrame);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoRestartTimer?.cancel();
    _focusNode.dispose();
    _game
      ..removeListener(_onGameChanged)
      ..dispose();
    super.dispose();
  }

  void _onGameChanged() {
    if (_game.isGameOver && _autoRestartTimer == null) {
      _autoRestartTimer = Timer(const Duration(milliseconds: 1500), () {
        _autoRestartTimer = null;
        if (mounted) {
          _restart();
        }
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onFrame(Timer timer) {
    final now = DateTime.now();
    if (now.difference(_lastDrop).inMilliseconds >= _game.dropIntervalMs) {
      _game.tick();
      _lastDrop = now;
    }
  }

  void _restart() {
    _autoRestartTimer?.cancel();
    _autoRestartTimer = null;
    _game.reset();
    _lastDrop = DateTime.now();
    _focusNode.requestFocus();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) {
      return;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _game.moveLeft();
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _game.moveRight();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _game.rotate();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _game.softDrop();
    } else if (key == LogicalKeyboardKey.space) {
      _game.hardDrop();
    } else if (key == LogicalKeyboardKey.keyP) {
      _game.togglePause();
    } else if (key == LogicalKeyboardKey.keyR) {
      _restart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _handleKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFE1E8E5),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;
              final gameLayout = isWide
                  ? _DesktopGameLayout(
                      game: _game,
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                      onPauseToggle: _game.togglePause,
                      onRestart: _restart,
                    )
                  : _MobileGameLayout(
                      game: _game,
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                      onPauseToggle: _game.togglePause,
                      onRestart: _restart,
                    );
              return Stack(
                children: [
                  gameLayout,
                  _PauseTransition(
                    visible: _game.isPaused,
                    onResume: _game.togglePause,
                  ),
                  _GameOverTransition(visible: _game.isGameOver),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DesktopGameLayout extends StatelessWidget {
  const _DesktopGameLayout({
    required this.game,
    required this.maxHeight,
    required this.maxWidth,
    required this.onPauseToggle,
    required this.onRestart,
  });

  final TetrisGame game;
  final double maxHeight;
  final double maxWidth;
  final VoidCallback onPauseToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final availableHeight = max(0.0, maxHeight - 48);
    final boardWidth = min(390.0, min(availableHeight / 2, maxWidth - 290));
    final boardHeight = boardWidth * 2;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: boardWidth,
              child: TetrisBoard(game: game),
            ),
            const SizedBox(width: 18),
            SizedBox(
              height: boardHeight,
              child: GamePanel(
                game: game,
                onPauseToggle: onPauseToggle,
                onRestart: onRestart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileGameLayout extends StatelessWidget {
  const _MobileGameLayout({
    required this.game,
    required this.maxHeight,
    required this.maxWidth,
    required this.onPauseToggle,
    required this.onRestart,
  });

  final TetrisGame game;
  final double maxHeight;
  final double maxWidth;
  final VoidCallback onPauseToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final boardWidth = min(maxWidth - 28, min(330.0, maxHeight * 0.36));

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
          width: min(maxWidth - 28, 430),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CompactScoreboard(
                game: game,
                onPauseToggle: onPauseToggle,
                onRestart: onRestart,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: boardWidth,
                child: TetrisBoard(game: game),
              ),
              const SizedBox(height: 16),
              MobileControls(
                onLeft: game.moveLeft,
                onRight: game.moveRight,
                onRotate: game.rotate,
                onSoftDrop: game.softDrop,
                onHardDrop: game.hardDrop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactScoreboard extends StatelessWidget {
  const _CompactScoreboard({
    required this.game,
    required this.onPauseToggle,
    required this.onRestart,
  });

  final TetrisGame game;
  final VoidCallback onPauseToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF14211F),
        border: Border.all(color: const Color(0xFF2BB7A8), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _MiniStat(label: 'Nivel', value: '${game.level}')),
          Expanded(child: _MiniStat(label: 'Pontos', value: '${game.score}')),
          Expanded(
            child: _MiniStat(label: 'Linhas', value: '${game.linesCleared}'),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Reiniciar',
            color: const Color(0xFF5EEAD4),
            onPressed: onRestart,
            icon: const Icon(Icons.restart_alt),
          ),
          IconButton(
            tooltip: game.isPaused ? 'Continuar' : 'Pausar',
            color: const Color(0xFF5EEAD4),
            onPressed: onPauseToggle,
            icon: Icon(game.isPaused ? Icons.play_arrow : Icons.pause),
          ),
        ],
      ),
    );
  }
}

class _PauseTransition extends StatelessWidget {
  const _PauseTransition({
    required this.visible,
    required this.onResume,
  });

  final bool visible;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: visible ? 1 : 0,
        child: Container(
          color: const Color(0x6614211F),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF14211F),
              border: Border.all(color: const Color(0xFF5EEAD4), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PAUSADO',
                  style: TextStyle(
                    color: Color(0xFFE8FFFA),
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onResume,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameOverTransition extends StatelessWidget {
  const _GameOverTransition({
    required this.visible,
  });

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        opacity: visible ? 1 : 0,
        child: Container(
          color: const Color(0xCC14211F),
          alignment: Alignment.center,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            scale: visible ? 1 : 0.88,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                border: Border.all(color: const Color(0xFFFFE0E0), width: 3),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GAME OVER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reiniciando...',
                    style: TextStyle(
                      color: Color(0xFFFFE0E0),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9FB8B2),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE8FFFA),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

