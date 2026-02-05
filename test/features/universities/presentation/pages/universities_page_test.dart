import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:frontend_test/features/universities/domain/repositories/universities_repository.dart';
import 'package:frontend_test/features/universities/presentation/pages/universities_page.dart';
import 'package:frontend_test/features/universities/presentation/bloc/universities_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'universities_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UniversitiesRepository>()])
void main() {
  late MockUniversitiesRepository repository;

  const testUniversities = [
    University(
      name: 'Test University',
      country: 'Test Country',
      stateProvince: 'Test State',
      webPages: ['https://example.com'],
      domains: ['example.com'],
      alphaTwoCode: '1234567890',
    ),
  ];

  setUp(() {
    repository = MockUniversitiesRepository();

    if (di.getIt.isRegistered<UniversitiesRepository>()) {
      di.getIt.unregister<UniversitiesRepository>();
    }
    if (di.getIt.isRegistered<UniversitiesBloc>()) {
      di.getIt.unregister<UniversitiesBloc>();
    }

    di.getIt.registerLazySingleton<UniversitiesRepository>(() => repository);
    di.getIt.registerFactory(
      () => UniversitiesBloc(universitiesRepository: di.getIt()),
    );

    when(
      repository.getUniversities(),
    ).thenAnswer((_) async => Either.right(testUniversities));
  });

  tearDown(() async {
    reset(repository);
    await di.getIt.reset();
  });

  group('UniversitiesPage - Initialization', () {
    testWidgets('should load universities on initialization', (tester) async {
      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(testUniversities));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      verify(repository.getUniversities()).called(1);

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.byKey(const Key('list_view')), findsOneWidget);
    });

    testWidgets('should display loading indicator initially', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message on failure', (tester) async {
      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.left(HttpRequestFailure.local()));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.text('Error al cargar'), findsOneWidget);
    });

    testWidgets('should display university name in list', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.textContaining('Test University'), findsOneWidget);
    });
  });

  group('UniversitiesPage - View Toggle', () {
    testWidgets('should toggle between list and grid view', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Inicialmente debe mostrar vista de lista
      expect(find.byKey(const Key('list_view')), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsOneWidget);

      // Tap en el botón de cambio de vista
      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pump();
      await tester.pump();

      // Ahora debe mostrar vista de grilla
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byIcon(Icons.view_list), findsOneWidget);
    });
  });

  group('UniversitiesPage - UI Elements', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.text('Universidades'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display view toggle button', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.byType(IconButton), findsWidgets);
    });
  });

  group('UniversitiesPage - Data Display', () {
    testWidgets('should display student count when available', (tester) async {
      const universitiesWithStudents = [
        University(
          name: 'Test University',
          country: 'Test Country',
          stateProvince: 'Test State',
          webPages: ['https://example.com'],
          domains: ['example.com'],
          alphaTwoCode: '1234567890',
          studentCount: 5000,
        ),
      ];

      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(universitiesWithStudents));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.textContaining('Estudiantes: 5000'), findsOneWidget);
    });

    testWidgets('should display multiple universities', (tester) async {
      const multipleUniversities = [
        University(
          name: 'University One',
          country: 'Country One',
          alphaTwoCode: 'C1',
        ),
        University(
          name: 'University Two',
          country: 'Country Two',
          alphaTwoCode: 'C2',
        ),
        University(
          name: 'University Three',
          country: 'Country Three',
          alphaTwoCode: 'C3',
        ),
      ];

      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(multipleUniversities));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.textContaining('University One'), findsOneWidget);
      expect(find.textContaining('University Two'), findsOneWidget);
      expect(find.textContaining('University Three'), findsOneWidget);
    });
  });

  group('UniversitiesPage - Grid View', () {
    testWidgets('should display universities in grid view', (tester) async {
      const multipleUniversities = [
        University(
          name: 'University One',
          country: 'Country One',
          alphaTwoCode: 'C1',
        ),
        University(
          name: 'University Two',
          country: 'Country Two',
          alphaTwoCode: 'C2',
        ),
      ];

      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(multipleUniversities));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Cambiar a vista de grilla
      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pump();
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
      expect(find.textContaining('University One'), findsOneWidget);
    });

    testWidgets('should display student count in grid view', (tester) async {
      const universitiesWithStudents = [
        University(
          name: 'Test University',
          country: 'Test Country',
          alphaTwoCode: 'TC',
          studentCount: 5000,
        ),
      ];

      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(universitiesWithStudents));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Cambiar a vista de grilla
      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Estudiantes: 5000'), findsOneWidget);
    });

    testWidgets('should display icon when no image in grid view', (
      tester,
    ) async {
      const universitiesWithoutImage = [
        University(
          name: 'Test University',
          country: 'Test Country',
          alphaTwoCode: 'TC',
        ),
      ];

      when(
        repository.getUniversities(),
      ).thenAnswer((_) async => Either.right(universitiesWithoutImage));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();

      // Cambiar a vista de grilla
      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.school), findsOneWidget);
    });
  });
}

Widget buildTestableWidget() {
  return const MaterialApp(home: UniversitiesPage());
}
