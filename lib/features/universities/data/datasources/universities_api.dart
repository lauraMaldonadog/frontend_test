import 'package:frontend_test/core/api/api_endpoints.dart';
import 'package:frontend_test/core/http/http.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';

// API de universidades
class UniversitiesApi {
  UniversitiesApi({required this.http});
  final CoreHttp http;

  // Obtener universidades
  Future<HttpResult<List<University>>> getUniversities() async {
    return await http.send(
      Api.getUniversities,
      method: HttpMethod.get,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      parser: (_, json) {
        final List<University> universities = List<University>.from(
          json.map((e) => University.fromJson(e)),
        );
        return universities;
      },
    );
  }
}
