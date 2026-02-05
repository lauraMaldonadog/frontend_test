import 'dart:convert';

import 'package:http/http.dart';

/// La clase `CoreHttp` es un wrapper para hacer solicitudes HTTP, manejar respuestas y devolver un resultado
/// indicando success o failure.
class CoreHttp {
  CoreHttp(this._baseUrl, this._client);
  final String _baseUrl;
  final Client _client;

  // Enviar una solicitud HTTP y devolver un HttpResult
  Future<HttpResult<T>> send<T>(
    String path, {
    required T Function(int, dynamic) parser,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
  }) async {
    late Request request;
    Response? response;
    try {
      late Uri url;
      if (path.startsWith('http')) {
        url = Uri.parse(path);
      } else {
        if (!path.startsWith('/')) {
          path = '/$path';
        }
        url = Uri.parse('$_baseUrl$path');
      }
      url = url.replace(queryParameters: queryParameters);
      request = Request(method.name, url);
      request.headers.addAll({
        'Content-Type': 'application/json; charset=utf-8',
        ...headers,
      });
      if (method != HttpMethod.get) {
        request.body = jsonEncode(body);
      }
      final stream = await _client.send(request);
      response = await Response.fromStream(stream);
      final statusCode = response.statusCode;
      final responseBody = _bodyParser(response.body);

      if (statusCode >= 200 && statusCode <= 300) {
        return HttpSuccess(statusCode, parser(statusCode, responseBody));
      }
      return HttpFailure(statusCode, responseBody);
    } catch (e) {
      return HttpFailure(response?.statusCode, e);
    }
  }
}

/// The `enum HttpMethod` is defining a set of HTTP methods that can be used in HTTP requests. These
/// methods include `get`, `post`, `patch`, `put`, and `delete`, which correspond to the common HTTP
/// methods used for retrieving, creating, updating, and deleting resources on a server.
enum HttpMethod { get, post, patch, put, delete }

/// The class `HttpResult` is an abstract class that represents the result of an HTTP request and
/// contains a nullable `statusCode` property.
abstract class HttpResult<T> {
  HttpResult(this.statusCode);
  final int? statusCode;
}

/// The class `HttpSuccess` is a subclass of `HttpResult` that represents a successful HTTP response
/// with a generic data type.
class HttpSuccess<T> extends HttpResult<T> {
  HttpSuccess(super.statusCode, this.data);
  final T data;
}

/// The class `HttpFailure` represents a failed HTTP result with an optional data object.
class HttpFailure<T> extends HttpResult<T> {
  HttpFailure(super.statusCode, this.data);
  final Object? data;
}

/// The function `_bodyParser` parses a JSON response body and returns the decoded JSON object, or
/// returns the original response body if parsing fails.
///
/// Args:
///   responseBody (String): The `responseBody` parameter is a string that represents the response body
/// received from an HTTP request.
///
/// Returns:
///   the parsed JSON object if the parsing is successful, otherwise it returns the original response
/// body.
dynamic _bodyParser(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (_) {
    return responseBody;
  }
}
