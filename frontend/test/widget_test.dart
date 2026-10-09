import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_app/main.dart';

void main() {
  testWidgets('muestra el panel inicial de ORBIT', (tester) async {
    await tester.pumpWidget(const OrbitApp());

    expect(find.byType(Image), findsWidgets);
    expect(find.text('Próximas citas'), findsOneWidget);
    expect(find.text('María Fernanda López'), findsOneWidget);
  });
}
