import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';

// Repositorio de universidades
abstract class UniversitiesRepository {
  Future<Either<HttpRequestFailure, List<University>>> getUniversities();
}
