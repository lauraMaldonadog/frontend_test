import 'package:envied/envied.dart';
// Variables de entorno
part 'env.g.dart'; 
// Clase para las variables de entorno
@Envied(path: '.env')
abstract class Env {
  Env._();

  // URL base de la API
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _Env.baseUrl;

}
