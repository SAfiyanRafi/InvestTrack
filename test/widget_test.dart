import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/shared/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders text and triggers callback on tap', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppButton(
              text: 'Tap Me',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    // Verify text is displayed
    expect(find.text('Tap Me'), findsOneWidget);

    // Tap the button and trigger animation transition
    await tester.tap(find.text('Tap Me'));
    await tester.pumpAndSettle();

    // Verify callback was fired
    expect(tapped, isTrue);
  });
}
