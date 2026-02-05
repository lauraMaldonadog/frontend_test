import 'dart:io';

import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/core/http/http.dart';
import 'package:frontend_test/shared/utils/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getDouble', () {});
  group('performHttpRequest', () {
    test(
      'Given a successful HttpResult, when it is called, it should return Either.right',
      () async {
        //GIVEN
        final mockHttpResult = HttpSuccess(200, 'Mock data');

        //WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        //THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
        expect(result.value, 'Mock data');
      },
    );

    test(
      'Given a HttpFailure due to network error, it should return HttpRequestFailure.network',
      () async {
        //GIVEN
        final mockHttpResult = HttpFailure<String>(
          000,
          HttpFailure(null, const SocketException('Test SocketException')),
        );

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );

    test(
      'Given a HttpFailure due to local, it should return HttpRequestFailure.local',
      () async {
        //GIVEN
        final mockHttpResult = HttpFailure<String>(
          000,
          HttpFailure(null, Exception('Test Exception')),
        );

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );

    test(
      'Given a failed HttpResult with status code 404, when it is called, it should return HttpRequestFailure.notFound',
      () async {
        // GIVEN
        final mockHttpResult = HttpFailure<String>(404, 'Not Found');

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );

    test(
      'Given a failed HttpResult with status code 401, when it is called, it should return HttpRequestFailure.unauthorized',
      () async {
        // GIVEN
        final mockHttpResult = HttpFailure<String>(401, 'unauthorized');

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );
    test(
      'Given a failed HttpResult with status code 403, when it is called, it should return HttpRequestFailure.unauthorized',
      () async {
        // GIVEN
        final mockHttpResult = HttpFailure<String>(403, 'unauthorized');

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );

    test(
      'Given a failed HttpResult with status code 400, when it is called, it should return HttpRequestFailure.badRequest',
      () async {
        // GIVEN
        final mockHttpResult = HttpFailure<String>(400, 'badRequest');

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );

    test(
      'Given a failed HttpResult with status code 500, when it is called, it should return HttpRequestFailure.server',
      () async {
        // GIVEN
        final mockHttpResult = HttpFailure<String>(500, 'server');

        // WHEN
        final result = await Util.performHttpRequest<String>(
          Future.value(mockHttpResult),
        );

        // THEN
        expect(result, isA<Either<HttpRequestFailure, String>>());
      },
    );
  });

  group('failDueToNetwork', () {
    test('should return true for SocketException', () {
      //GIVEN
      final failure = HttpFailure(
        null,
        const SocketException('Test SocketException'),
      );

      //WHEN
      final result = Util.failDueToNetwork(failure);

      //EXPECT
      expect(result, true);
    });

    test('should return false for other types of failures', () {
      //GIVEN
      final failure = HttpFailure(null, Exception('Test Exception'));

      //WHEN
      final result = Util.failDueToNetwork(failure);

      //EXPECT
      expect(result, false);
    });
  });

  group('failDueToParser', () {
    test('should return true for non-serializable data types', () {
      // Simulate a failure with data that cannot be parsed
      //GIVEN
      final failure1 = HttpFailure<dynamic>(null, 123); // Integer data
      final failure2 = HttpFailure<dynamic>(null, 3.14); // Double data
      final failure3 = HttpFailure<dynamic>(null, true); // Boolean data

      //WHEN
      final result1 = Util.failDueToParser(failure1);
      final result2 = Util.failDueToParser(failure2);
      final result3 = Util.failDueToParser(failure3);

      //EXPECT
      expect(result1, true);
      expect(result2, true);
      expect(result3, true);
    });

    test('should return false for serializable data types', () {
      // Simulate failures with data that can be parsed
      //GIVEN
      final failure1 = HttpFailure<dynamic>(
        null,
        'Error message',
      ); // String data
      final failure2 = HttpFailure<dynamic>(null, {
        'error': 'Error message',
      }); // Map data
      final failure3 = HttpFailure<dynamic>(null, [
        'Error message',
      ]); // List data

      //WHEN
      final result1 = Util.failDueToParser(failure1);
      final result2 = Util.failDueToParser(failure2);
      final result3 = Util.failDueToParser(failure3);

      //EXPECT
      expect(result1, false);
      expect(result2, false);
      expect(result3, false);
    });
  });
}
