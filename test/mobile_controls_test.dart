import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_flutter/widgets/mobile_controls.dart';

void main() {
  testWidgets('exposes soft drop and hard drop controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MobileControls(
            onLeft: () {},
            onRight: () {},
            onRotate: () {},
            onSoftDrop: () {},
            onHardDrop: () {},
          ),
        ),
      ),
    );

    expect(find.byTooltip('Queda suave'), findsOneWidget);
    expect(find.byTooltip('Soltar'), findsOneWidget);
  });
}

