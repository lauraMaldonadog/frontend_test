part of 'universities_bloc.dart';

enum ViewType { list, grid }

// Class for representing the state of a customer in the application.
@freezed
class UniversitiesState with _$UniversitiesState {
  const factory UniversitiesState.loading() = _Loading;
  const factory UniversitiesState.failed() = _Failed;
  const factory UniversitiesState.loaded({
    required List<University> universities,
    required List<University> allUniversities,
    required bool hasMore,
    required bool isLoadingMore,
    @Default(ViewType.list) ViewType viewType,
    String? selectedImagePath,
  }) = _Loaded;
}
