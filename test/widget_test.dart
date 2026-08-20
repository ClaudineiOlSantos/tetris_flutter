import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_flutter/main.dart';

void main() {
  testWidgets('renders the Tetris game screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TetrisApp());

    expect(find.text('TETRIS'), findsOneWidget);
    expect(find.text('Nivel'), findsOneWidget);
    expect(find.text('Pontuacao'), findsOneWidget);

    await tester.tap(find.text('Pausar'));
    await tester.pump();
    expect(find.text('PAUSADO'), findsOneWidget);

    await tester.tap(find.text('Continuar').last);
    await tester.pump();
    expect(find.text('Pausar'), findsOneWidget);

    expect(find.text('Reiniciar'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}

