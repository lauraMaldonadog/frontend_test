import 'package:frontend_test/core/environment/env.dart';
// Endpoints de la API
class Api {
  Api._();
  static String apiEndPoint = Env.baseUrl;

  static String getUniversities = '$apiEndPoint/universities.json';
}
