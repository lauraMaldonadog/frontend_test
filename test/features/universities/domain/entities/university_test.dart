
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';

void main() {
  group('University', () {
    test('fromJson should create instance correctly', () {
      // Arrange
      final json = {
        'alpha_two_code': '123456789',
        'domains': ['example.com'],
        'country': 'Test Country',
        'stateProvince': 'Test State',
        'webPages': ['https://example.com'],
        'name': 'Test University',
        'imagePath': 'image.png',
        'studentCount': 100,
      };

      // Act
      final result = University.fromJson(json);

      // Assert
      expect(result.alphaTwoCode, '123456789');
      expect(result.domains, ['example.com']);
      expect(result.country, 'Test Country');
      expect(result.stateProvince, 'Test State');
      expect(result.webPages, ['https://example.com']);
      expect(result.name, 'Test University');
      expect(result.imagePath, 'image.png');
      expect(result.studentCount, 100);
    });

    test('fromJson should use default values when optional fields are missing', () {
      // Arrange
      final json = {
        'alpha_two_code': '123456789',
        'domains': ['example.com'],
        'country': 'Test Country',
        'stateProvince': 'Test State',
        'webPages': ['https://example.com'],
        'name': 'Test University',
      };

      // Act
      final result = University.fromJson(json);

      // Assert
      expect(result.alphaTwoCode, '123456789');
      expect(result.domains, ['example.com']);
      expect(result.country, 'Test Country');
      expect(result.stateProvince, 'Test State');
      expect(result.webPages, ['https://example.com']);
      expect(result.name, 'Test University');
      expect(result.imagePath, null);
      expect(result.studentCount, null);
    });

    test('toJson should serialize correctly', () {
      // Arrange
      const instance = University(
        alphaTwoCode: '123456789',
        domains: ['example.com'],
        country: 'Test Country',
        stateProvince: 'Test State',
        webPages: ['https://example.com'],
        name: 'Test University',
        imagePath: 'image.png',
        studentCount: 100,
      );

      // Act
      final json = instance.toJson();

      // Assert
      expect(json['alpha_two_code'], '123456789');
      expect(json['domains'], ['example.com']);
      expect(json['country'], 'Test Country');
      expect(json['stateProvince'], 'Test State');
      expect(json['webPages'], ['https://example.com']);
      expect(json['name'], 'Test University');
      expect(json['imagePath'], 'image.png');
      expect(json['studentCount'], 100);
    });

    test('fromJson and toJson should be inverses', () {
      // Arrange
      final originalJson = {
        'alpha_two_code': '987654321',
        'domains': ['example.com'],
        'country': 'Another Country',
        'stateProvince': 'Another State',
        'webPages': ['https://example.com'],
        'name': 'Another University',
        'imagePath': 'image.png',
        'studentCount': 200,
      };

      // Act
      final instance = University.fromJson(originalJson);
      final resultJson = instance.toJson();

      // Assert
      expect(resultJson['alpha_two_code'], originalJson['alpha_two_code']);
      expect(resultJson['domains'], originalJson['domains']);
      expect(resultJson['country'], originalJson['country']);
      expect(resultJson['stateProvince'], originalJson['stateProvince']);
      expect(resultJson['webPages'], originalJson['webPages']);
      expect(resultJson['name'], originalJson['name']);
      expect(resultJson['imagePath'], originalJson['imagePath']);
      expect(resultJson['studentCount'], originalJson['studentCount']);
    });
  });
}