
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CookTime basic widget test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('CookTime'),
        ),
      ),
    );

    expect(find.text('CookTime'), findsOneWidget);
  });
}
