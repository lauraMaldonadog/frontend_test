import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:frontend_test/features/universities/presentation/pages/university_detail_page.dart';

void main() {
  const testUniversity = University(
    name: 'Test University',
    country: 'Test Country',
    stateProvince: 'Test State',
    webPages: ['https://example.com', 'https://test.com'],
    domains: ['example.com', 'test.com'],
    alphaTwoCode: 'TC',
  );

  const testUniversityWithData = University(
    name: 'University with Data',
    country: 'Test Country',
    stateProvince: 'Test State',
    webPages: ['https://example.com'],
    domains: ['example.com'],
    alphaTwoCode: 'TC',
    studentCount: 5000,
  );

  group('UniversityDetailPage - Initialization', () {
    testWidgets('should display university name in app bar', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test University'), findsWidgets);
    });

    testWidgets('should display university information', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Test Country'), findsWidgets);
      expect(find.text('TC'), findsOneWidget);
    });

    testWidgets('should show default image placeholder when no image', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Sin imagen'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsWidgets);
    });

    testWidgets('should initialize with existing student count', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversityWithData));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, '5000');
    });
  });

  group('UniversityDetailPage - Form Validation', () {
    testWidgets('should show error when student count is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      // Buscar el botón de guardar por ícono
      final saveButton = find.byIcon(Icons.save);
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Por favor ingresa el número de estudiantes'),
        findsOneWidget,
      );
    });

    testWidgets('should show error when student count is zero', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '0');
      await tester.pumpAndSettle();

      final saveButton = find.byIcon(Icons.save);
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('El número debe ser mayor a 0'), findsOneWidget);
    });

    testWidgets('should show error when student count exceeds limit', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '1000001');
      await tester.pumpAndSettle();

      final saveButton = find.byIcon(Icons.save);
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.text('El número no puede exceder 1,000,000'),
        findsOneWidget,
      );
    });

    testWidgets('should accept valid student count', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '5000');
      await tester.pumpAndSettle();

      final saveButton = find.byIcon(Icons.save);
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('✓ Datos guardados exitosamente'), findsOneWidget);
    });
  });

  group('UniversityDetailPage - Image Picker', () {
    testWidgets('should show image source dialog when button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add_a_photo));
      await tester.pumpAndSettle();

      expect(find.text('Seleccionar imagen'), findsOneWidget);
      expect(find.text('Cámara'), findsOneWidget);
      expect(find.text('Galería'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('should close dialog when cancel is tapped', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add_a_photo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Seleccionar imagen'), findsNothing);
    });

    testWidgets('should show change image button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Cambiar imagen'), findsOneWidget);
    });
  });

  group('UniversityDetailPage - Information Sections', () {
    testWidgets('should display general information section', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Información General'), findsOneWidget);
      expect(find.text('País'), findsOneWidget);
      expect(find.text('Código País'), findsOneWidget);
    });

    testWidgets('should display state/province when available', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Estado/Provincia'), findsOneWidget);
      expect(find.text('Test State'), findsOneWidget);
    });

    testWidgets('should display domains section', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Dominios'), findsOneWidget);
      expect(find.text('example.com'), findsOneWidget);
      expect(find.text('test.com'), findsOneWidget);
    });

    testWidgets('should display web pages section', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Enlaces'), findsOneWidget);
      expect(find.text('https://example.com'), findsOneWidget);
      expect(find.text('https://test.com'), findsOneWidget);
    });

    testWidgets('should not display sections when data is null', (
      tester,
    ) async {
      const universityWithoutOptionalData = University(
        name: 'Basic University',
        country: 'Country',
        alphaTwoCode: 'BC',
      );

      await tester.pumpWidget(
        buildTestableWidget(universityWithoutOptionalData),
      );
      await tester.pumpAndSettle();

      expect(find.text('Estado/Provincia'), findsNothing);
      expect(find.text('Dominios'), findsNothing);
      expect(find.text('Enlaces'), findsNothing);
    });
  });

  group('UniversityDetailPage - UI Elements', () {
    testWidgets('should display student count form field', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Número de Estudiantes'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should display save button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      final saveButton = find.byIcon(Icons.save);
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Guardar Datos'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('should have scrollable content', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display key icons', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.people), findsOneWidget);
      expect(find.byIcon(Icons.public), findsOneWidget);
      expect(find.byIcon(Icons.flag), findsOneWidget);
    });
  });

  group('UniversityDetailPage - Form Interaction', () {
    testWidgets('should allow entering text in student count field', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '12345');
      await tester.pumpAndSettle();

      expect(find.text('12345'), findsOneWidget);
    });

    testWidgets('should only accept digits in student count field', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'abc123def');
      await tester.pumpAndSettle();

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, '123');
    });
  });

  group('UniversityDetailPage - Cards and Layout', () {
    testWidgets('should display all cards', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('should display gradient header', (tester) async {
      await tester.pumpWidget(buildTestableWidget(testUniversity));
      await tester.pumpAndSettle();

      expect(find.text('Test University'), findsWidgets);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });
  });
}

Widget buildTestableWidget(University university) {
  return MaterialApp(
    home: UniversityDetailPage(university: university),
  );
}

