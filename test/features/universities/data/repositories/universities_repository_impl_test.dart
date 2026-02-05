import 'dart:convert';

import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/core/failure/http_request_failure.dart';
import 'package:frontend_test/core/http/http.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/features/universities/data/datasources/universities_api.dart';
import 'package:frontend_test/features/universities/data/repositories/unversities_repository_impl.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'universities_repository_impl_test.mocks.dart';

@GenerateMocks([dio.Dio, Client])
void main() {
  final mockClient = MockClient();
  final mockHttp = CoreHttp('', mockClient);
  final mockApi = UniversitiesApi(http: mockHttp);
  final UniversitiesRepositoryImpl repository = UniversitiesRepositoryImpl(
    universitiesApi: mockApi,
  );

  test('Given UniversitiesRepositoryImpl and UniversitiesApi, '
      'when consult is called'
      'then it should return a Universities', () async {
    final response = StreamedResponse(
      Stream.fromIterable([utf8.encode(_Responses.universitiesResponse)]),
      200,
    );

    // GIVEN
    when(mockClient.send(any)).thenAnswer((_) => Future.value(response));

    // WHEN
    final Either<HttpRequestFailure, dynamic> result = await repository
        .getUniversities();

    // THEN
    final dynamic content = result.value;
    expect(content, isA<List<University>>());
  });
}

class _Responses {
  static const universitiesResponse = '''[
    {
      "alpha_two_code": "US",
      "domains": [
        "marywood.edu"
      ],
      "country": "United States",
      "state-province": null,
      "web_pages": [
        "http://www.marywood.edu"
      ],
      "name": "Marywood University"
    },
    {
      "alpha_two_code": "US",
      "domains": [
        "lindenwood.edu"
      ],
      "country": "United States",
      "state-province": null,
      "web_pages": [
        "http://www.lindenwood.edu/"
      ],
      "name": "Lindenwood University"
    }
  ]''';
}
