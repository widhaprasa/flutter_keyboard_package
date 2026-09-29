import 'package:flutter/material.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';
import 'package:flutter_test/flutter_test.dart';

class _LayoutCase {
  const _LayoutCase({
    required this.name,
    required this.layout,
    required this.tapText,
    required this.expected,
  });

  final String name;
  final VirtualKeyboardLayout layout;
  final String tapText;
  final String expected;
}

void main() {
  group('comprehensive widget coverage', () {
    final layoutCases = <_LayoutCase>[
      _LayoutCase(
        name: 'numeric',
        layout: VirtualKeyboardLayout.numeric(),
        tapText: '1',
        expected: '1',
      ),
      _LayoutCase(
        name: 'numericDecimal',
        layout: VirtualKeyboardLayout.numericDecimal(),
        tapText: '.',
        expected: '.',
      ),
      _LayoutCase(
        name: 'alphanumeric',
        layout: VirtualKeyboardLayout.alphanumeric(),
        tapText: 'q',
        expected: 'q',
      ),
      _LayoutCase(
        name: 'alphabetic',
        layout: VirtualKeyboardLayout.alphabetic(),
        tapText: 'a',
        expected: 'a',
      ),
      _LayoutCase(
        name: 'specialCharacters',
        layout: VirtualKeyboardLayout.specialCharacters(),
        tapText: '1',
        expected: '1',
      ),
      _LayoutCase(
        name: 'specialCharactersSecondary',
        layout: VirtualKeyboardLayout.specialCharactersSecondary(),
        tapText: '[',
        expected: '[',
      ),
      _LayoutCase(
        name: 'email',
        layout: VirtualKeyboardLayout.email(),
        tapText: '@',
        expected: '@',
      ),
      _LayoutCase(
        name: 'url',
        layout: VirtualKeyboardLayout.url(),
        tapText: '/',
        expected: '/',
      ),
      _LayoutCase(
        name: 'phone',
        layout: VirtualKeyboardLayout.phone(),
        tapText: '*',
        expected: '*',
      ),
      _LayoutCase(
        name: 'hexadecimal',
        layout: VirtualKeyboardLayout.hexadecimal(),
        tapText: 'a',
        expected: 'a',
      ),
      _LayoutCase(
        name: 'calculator',
        layout: VirtualKeyboardLayout.calculator(),
        tapText: '7',
        expected: '7',
      ),
      _LayoutCase(
        name: 'otp',
        layout: VirtualKeyboardLayout.otp(),
        tapText: '1',
        expected: '1',
      ),
      _LayoutCase(
        name: 'date',
        layout: VirtualKeyboardLayout.date(),
        tapText: '/',
        expected: '/',
      ),
      _LayoutCase(
        name: 'time',
        layout: VirtualKeyboardLayout.time(),
        tapText: 'AM',
        expected: 'AM',
      ),
      _LayoutCase(
        name: 'currency',
        layout: VirtualKeyboardLayout.currency(),
        tapText: '\$',
        expected: '\$',
      ),
      _LayoutCase(
        name: 'scientificCalculator',
        layout: VirtualKeyboardLayout.scientificCalculator(),
        tapText: '^',
        expected: '^',
      ),
    ];

    for (final c in layoutCases) {
      testWidgets('${c.name} inserts tapped key text', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FlutterKeyboard(controller: controller, layout: c.layout),
            ),
          ),
        );

        await tester.tap(find.text(c.tapText).first);
        await tester.pump();

        expect(controller.text, c.expected);
      });
    }

    testWidgets('shift toggles uppercase and lowercase in alphanumeric', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterKeyboard(
              controller: controller,
              layout: VirtualKeyboardLayout.alphanumeric(),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await tester.tap(find.text('Q'));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pump();
      await tester.tap(find.text('w'));
      await tester.pump();

      expect(controller.text, 'Qw');
    });

    testWidgets('special toggle path ?123 -> #+= -> ABC works', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterKeyboard(
              controller: controller,
              layout: VirtualKeyboardLayout.email(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('?123'));
      await tester.pump();
      expect(find.text('#+='), findsOneWidget);

      await tester.tap(find.text('#+='));
      await tester.pump();
      expect(find.text('123'), findsOneWidget);

      await tester.tap(find.text('ABC'));
      await tester.pump();
      expect(find.text('q'), findsOneWidget);
    });

    testWidgets('calculator keyboard evaluates and reports errors', (
      tester,
    ) async {
      final controller = TextEditingController();
      String? error;
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalculatorKeyboard(
              controller: controller,
              onError: (value) => error = value,
              onEvaluated: (value) => result = value,
            ),
          ),
        ),
      );

      await tester.tap(find.text('1').first);
      await tester.pump();
      await tester.tap(find.text('/').first);
      await tester.pump();
      await tester.tap(find.text('0').first);
      await tester.pump();
      await tester.tap(find.text('=').first);
      await tester.pump();
      await tester.pump();

      expect(error, isNotNull);

      controller.clear();
      await tester.tap(find.text('9').first);
      await tester.pump();
      await tester.tap(find.text('/').first);
      await tester.pump();
      await tester.tap(find.text('3').first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(result, '3');
      expect(controller.text, '3');
    });
  });
}
