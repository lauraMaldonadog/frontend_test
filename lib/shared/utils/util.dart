import 'dart:io';

import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/core/http/http.dart';

import 'package:dio/dio.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

// Clase para las utilidades
class Util {
  Util._();

  // Realizar una solicitud HTTP y devolver un Either con el resultado de la solicitud
  static Future<Either<HttpRequestFailure, T>> performHttpRequest<T>(
    Future<HttpResult<T>> future,
  ) async {
    final result = await future;
    if (result is HttpFailure<T>) {
      HttpRequestFailure? failure;
      if (failDueToNetwork(result)) {
        failure = HttpRequestFailure.network();
      } else if (failDueToParser(result)) {
        failure = HttpRequestFailure.local();
      } else {
        Map<String, dynamic>? value;
        String? msg;
        int? status;
        if (result.data is Map<String, dynamic>) {
          value = result.data as Map<String, dynamic>;
          msg = value['message'];
          status = value['status'];
        }
        switch (result.statusCode) {
          case 404:
            failure = HttpRequestFailure.notFound(msg: msg, status: status);
            break;
          case 401:
          case 403:
            failure = HttpRequestFailure.unauthorized(msg: msg, status: status);
            break;
          case 400:
            failure = HttpRequestFailure.badRequest(msg: msg, status: status);
            break;
          default:
            failure = HttpRequestFailure.server(msg: msg, status: status);
        }
      }

      return Either.left(failure);
    }
    return Either.right((result as HttpSuccess).data);
  }

  /// La función verifica si un fallo es debido a un problema de red verificando si los datos del fallo son un SocketException o un ClientException.
  ///
  /// Args:
  ///   failure `(HttpFailure<T>)`: El parámetro "failure" es de tipo `HttpFailure<T>`, donde T es un tipo genérico.
  ///
  /// Returns:
  ///   un valor booleano.
  static bool failDueToNetwork<T>(HttpFailure<T> failure) {
    final data = failure.data;
    if (data is DioException) {
      if (data.error is SocketException) {
        return true;
      }
    }
    return data is SocketException || data is ClientException;
  }

  /// La función verifica si los datos en un objeto HttpFailure no son una String, Map o List.
  ///
  /// Args:
  ///   failure `(HttpFailure<T>)`: El parámetro "failure" es de tipo `HttpFailure<T>`.
  ///
  /// Returns:
  ///   un valor booleano.
  static bool failDueToParser<T>(HttpFailure<T> failure) {
    final data = failure.data;
    return data is! String && data is! Map && data is! List;
  }
}
