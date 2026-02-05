import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

/// La clase `HttpRequestFailure` define diferentes tipos de fallos de solicitud HTTP usando el paquete freezed en Dart.
@freezed
abstract class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.network({String? msg, int? status}) = _Network;
  factory HttpRequestFailure.notFound({String? msg, int? status}) = _NotFound;
  factory HttpRequestFailure.server({String? msg, int? status}) = _Server;
  factory HttpRequestFailure.unauthorized({String? msg, int? status}) =
      _Unauthorized;
  factory HttpRequestFailure.badRequest({String? msg, int? status}) =
      _BadRequest;
  factory HttpRequestFailure.local({String? msg, int? status}) = _Local;
}
