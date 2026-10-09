import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_app/main.dart';
import 'package:orbit_app/features/ui_states/ui_states_screen.dart';

void main() {
  testWidgets('muestra el panel inicial de ORBIT', (tester) async {
    await tester.pumpWidget(const OrbitApp());

    expect(find.byType(Image), findsWidgets);
    expect(find.text('Próximas citas'), findsOneWidget);
    expect(find.text('María Fernanda López'), findsOneWidget);
  });

  testWidgets('permite revisar los estados de interfaz', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UiStatesScreen())),
    );

    expect(find.text('Estados UI'), findsOneWidget);
    await tester.tap(find.text('Error'));
    await tester.pumpAndSettle();
    expect(find.text('No pudimos cargar la información'), findsOneWidget);
  });
}
