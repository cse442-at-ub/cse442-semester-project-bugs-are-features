import 'package:Inspectre/app.dart';
import 'package:Inspectre/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // TODO: Make these tests work. Requires learning Flutter testing...
  testWidgets('App mounts RootPage() widget', (WidgetTester tester) async {
    await tester.pumpWidget(App());
    Material root = Material(
      child: RootPage(),
    );
    // Finds our RootPage widget
    expect(find.byWidget(root), findsOneWidget);
  });

  testWidgets('App mounts RootPage() widget', (WidgetTester tester) async {
    await tester.pumpWidget(RootPage());
    // Verify that splash screen displays "Ghost App".
    expect(find.text('Ghost App'), findsOneWidget);
  });
}
