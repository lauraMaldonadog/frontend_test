import 'package:frontend_test/features/universities/presentation/pages/university_detail_page.dart';
import 'package:frontend_test/features/universities/presentation/pages/universities_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:frontend_test/features/home/presentation/pages/home_page.dart';

// Router de la aplicacion
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Ruta para la pagina de inicio
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // Ruta para la pagina de universidades
      GoRoute(
        path: '/universities',
        name: 'universities',
        builder: (context, state) {
          return UniversitiesPage();
        },
      ),
      // Ruta para la pagina de detalle de universidad
      GoRoute(  
        path: '/university-detail',
        name: 'university-detail',
        builder: (context, state) {
          final university = state.extra as University;
          return UniversityDetailPage(university: university);
        },
      ),
    ],
  );
}
