// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bateria_mobile/views/search/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App name is shown on app bar', (WidgetTester tester) async {
    // Arrange and act
    await tester.pumpWidget(getAppWrapper(const SearchPageAppBar()));

    // Assert
    expect(find.text('Bateria'), findsOneWidget);
  });

  testWidgets('Search opens a new page with correct placeholder',
      (WidgetTester tester) async {
    // Arrange and act
    await tester.pumpWidget(getAppWrapper(const SearchPageAppBar()));

    // Assert
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byTooltip('Buscar por endereço'), findsOneWidget);

    expect(find.byIcon(Icons.my_location_sharp), findsOneWidget);
    expect(find.byTooltip('Buscar por localização atual'), findsOneWidget);
  });
}

Widget getAppWrapper(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}
