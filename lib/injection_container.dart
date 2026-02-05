import 'package:frontend_test/features/universities/data/datasources/universities_api.dart';
import 'package:frontend_test/features/universities/data/repositories/unversities_repository_impl.dart';
import 'package:frontend_test/features/universities/domain/repositories/universities_repository.dart';
import 'package:frontend_test/features/universities/presentation/bloc/universities_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:frontend_test/core/environment/env.dart';
import 'package:frontend_test/core/http/http.dart';

// Injection Container
final getIt = GetIt.instance;
// Archivo para la inyección de dependencias
void init() {
  // Features
  getIt.registerFactory(
    () => UniversitiesBloc(universitiesRepository: getIt()),
  );
  // Repositories
  getIt.registerLazySingleton<UniversitiesRepository>(
    () => UniversitiesRepositoryImpl(universitiesApi: getIt()),
  );

  //! Datasources
  getIt.registerLazySingleton(() => UniversitiesApi(http: getIt()));

  //! Core
  getIt.registerLazySingleton(() => CoreHttp(Env.baseUrl, getIt()));
  getIt.registerLazySingleton(() => Client());
}
