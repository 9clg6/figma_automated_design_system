import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget in a MaterialApp for golden testing.
Widget goldenTestApp(Widget child, {Size size = const Size(400, 600)}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF0A84FF),
    ),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

/// Pumps a widget sized for golden testing.
Future<void> pumpGolden(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(400, 600),
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(goldenTestApp(widget, size: size));
  await tester.pumpAndSettle();
}
