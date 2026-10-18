import 'dart:ui' show CheckedState, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radflow/app/pages/calculators/app_prostate_volume_calculator.dart';
import 'package:radflow/app/pages/designer/_designer_input.dart';
import 'package:radflow/app/pages/design_ward/_ward_common_input.dart';
import 'package:radflow/app/widgets/control_semantics.dart';
import 'package:radflow/app/widgets/dropdowns_three.dart';
import 'package:radflow/app/router.dart';

Finder control(String label) => find.byWidgetPredicate(
  (widget) => widget is ControlSemantics && widget.label == label,
);

Finder field(String label) =>
    find.descendant(of: control(label), matching: find.byType(TextField));

Future<void> showForm(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(1600, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

void main() {
  testWidgets('menu and version actions have independent named button nodes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: AppRouter.router)),
    );
    await tester.pumpAndSettle();
    final menu = find.semantics.byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().label == 'Open navigation menu',
    );
    final version = find.semantics.byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().label == 'Version information',
    );
    expect(
      menu.evaluate().single.getSemanticsData().flagsCollection.isButton,
      isTrue,
    );
    expect(
      version.evaluate().single.getSemanticsData().flagsCollection.isButton,
      isTrue,
    );
    tester.semantics.tap(version);
    await tester.pumpAndSettle();
    expect(find.text('Close'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    tester.semantics.tap(menu);
    await tester.pumpAndSettle();
    expect(find.text('Menu'), findsOneWidget);
  });

  testWidgets('field names stay separate from editable values and actions', (
    tester,
  ) async {
    await showForm(tester, const AppProstateVolumeCalculator());

    final input = field('Prostate diameters (cm)');
    final group = tester.getSemantics(control('Prostate diameters (cm)'));
    final editableFinder = find.descendant(
      of: input,
      matching: find.byType(EditableText),
    );
    final editable = tester.getSemantics(editableFinder);
    expect(group.label, 'Prostate diameters (cm)');
    expect(editable.flagsCollection.isTextField, isTrue);
    expect(editable.id, isNot(group.id));

    await tester.tap(input);
    await tester.pumpAndSettle();
    expect(
      tester
          .getSemantics(editableFinder)
          .getSemanticsData()
          .hasAction(SemanticsAction.setText),
      isTrue,
    );

    await tester.enterText(input, '4 5 6');
    await tester.pump();
    expect(tester.getSemantics(editableFinder).value, '4 5 6');
    expect(group.label, 'Prostate diameters (cm)');
    expect(find.bySemanticsLabel('Generate prostate volume'), findsOneWidget);
    expect(find.bySemanticsLabel('Copy prostate volume'), findsOneWidget);
    expect(find.bySemanticsLabel('Reset prostate volume'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Reset prostate volume'));
    await tester.pump();
    expect(tester.getSemantics(editableFinder).value, isEmpty);
  });

  testWidgets('cascading menus keep names, selection and disabled state', (
    tester,
  ) async {
    Map<String, String?>? selection;
    await showForm(
      tester,
      ThreeLevelDropdowns(
        choiceIdMap: const {
          'body': {
            'exam': ['routine'],
          },
        },
        idDispMap: const {
          'body': 'Body',
          'exam': 'Test exam',
          'routine': 'Test protocol',
        },
        onSelectionChanged: (value) => selection = value,
      ),
    );

    expect(tester.widget<TextField>(field('Exam')).enabled, isFalse);
    expect(tester.widget<TextField>(field('Protocol')).enabled, isFalse);
    await tester.tap(field('Category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Body').last);
    await tester.pumpAndSettle();
    expect(selection?['level1'], 'body');
    expect(tester.getSemantics(control('Category')).label, 'Category');
    expect(tester.getSemantics(field('Category')).value, 'Body');
    expect(tester.widget<TextField>(field('Exam')).enabled, isTrue);

    await tester.tap(field('Exam'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Test exam').last);
    await tester.pumpAndSettle();
    await tester.tap(field('Protocol'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Test protocol').last);
    await tester.pumpAndSettle();
    expect(selection, {
      'level1': 'body',
      'level2': 'exam',
      'level3': 'routine',
    });
    expect(tester.getSemantics(field('Protocol')).value, 'Test protocol');
    expect(tester.takeException(), isNull);
  });

  testWidgets('ER checkbox names belong to actionable checked-state nodes', (
    tester,
  ) async {
    Map<String, dynamic>? values;
    await showForm(
      tester,
      DesignERInput(onSelectionChanged: (value) => values = value),
    );

    for (final label in ['ETT', 'C1', 'Pregnancy']) {
      final node = tester.getSemantics(find.bySemanticsLabel(label));
      expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    }
    tester.semantics.tap(find.semantics.byLabel('Pregnancy'));
    await tester.pump();
    expect(values?['pregnancy'], isTrue);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('Pregnancy'))
          .flagsCollection
          .isChecked,
      CheckedState.isTrue,
    );
  });

  testWidgets('ward checkbox labels preserve dependent enabled states', (
    tester,
  ) async {
    await showForm(tester, WardCommonInput(onChanged: (_) {}));
    final before = find.bySemanticsLabel('ก่อน IV contrast');
    expect(
      tester.getSemantics(before).flagsCollection.isEnabled,
      Tristate.isFalse,
    );
    await tester.tap(find.bySemanticsLabel('Check ภาพ'));
    await tester.pump();
    expect(
      tester.getSemantics(before).flagsCollection.isEnabled,
      Tristate.isTrue,
    );
    expect(control('Protocol author role'), findsOneWidget);
    expect(control('Name'), findsOneWidget);
    expect(control('Tel.'), findsOneWidget);
  });
}
