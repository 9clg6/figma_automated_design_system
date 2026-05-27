import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:linagora_design_flutter/side_sheet/twake_side_sheet.dart';

void main() {
  group('TwakeSideSheet golden tests', () {
    testGoldens('standard_no_back_no_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.standard,
            showBack: false,
            showActions: false,
            title: 'Title',
            onClose: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_standard_no_back_no_actions');
    });

    testGoldens('standard_back_no_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.standard,
            showBack: true,
            showActions: false,
            title: 'Title',
            onClose: () {},
            onBack: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_standard_back_no_actions');
    });

    testGoldens('standard_no_back_with_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.standard,
            showBack: false,
            showActions: true,
            title: 'Title',
            onClose: () {},
            onSave: () {},
            onCancel: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_standard_no_back_with_actions');
    });

    testGoldens('standard_back_with_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.standard,
            showBack: true,
            showActions: true,
            title: 'Title',
            onClose: () {},
            onBack: () {},
            onSave: () {},
            onCancel: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_standard_back_with_actions');
    });

    testGoldens('modal_no_back_no_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.modal,
            showBack: false,
            showActions: false,
            title: 'Title',
            onClose: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_modal_no_back_no_actions');
    });

    testGoldens('modal_back_no_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.modal,
            showBack: true,
            showActions: false,
            title: 'Title',
            onClose: () {},
            onBack: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_modal_back_no_actions');
    });

    testGoldens('modal_no_back_with_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.modal,
            showBack: false,
            showActions: true,
            title: 'Title',
            onClose: () {},
            onSave: () {},
            onCancel: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_modal_no_back_with_actions');
    });

    testGoldens('modal_back_with_actions', (tester) async {
      await tester.pumpWidgetBuilder(
        _buildScaffold(
          TwakeSideSheet(
            type: TwakeSideSheetType.modal,
            showBack: true,
            showActions: true,
            title: 'Title',
            onClose: () {},
            onBack: () {},
            onSave: () {},
            onCancel: () {},
          ),
        ),
        surfaceSize: const Size(300, 480),
      );
      await screenMatchesGolden(tester, 'side_sheet_modal_back_with_actions');
    });
  });
}

Widget _buildScaffold(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 280,
          height: 460,
          child: child,
        ),
      ),
    ),
  );
}
