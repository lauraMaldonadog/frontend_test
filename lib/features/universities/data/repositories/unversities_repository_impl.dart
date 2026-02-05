import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/features/universities/data/datasources/universities_api.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:frontend_test/features/universities/domain/repositories/universities_repository.dart';
import 'package:frontend_test/shared/utils/util.dart';

// Implementacion del repositorio de universidades
class UniversitiesRepositoryImpl implements UniversitiesRepository {
  UniversitiesRepositoryImpl({required this.universitiesApi});

  final UniversitiesApi universitiesApi;
  @override
  Future<Either<HttpRequestFailure, List<University>>> getUniversities() async {
    return Util.performHttpRequest(universitiesApi.getUniversities());
  }
}
