part of 'universities_bloc.dart';

@freezed
class UniversitiesEvent with _$UniversitiesEvent {
  const factory UniversitiesEvent.getUniversities() = _GetUniversitiesEvent;
  const factory UniversitiesEvent.toggleView() = _ToggleViewEvent;
  const factory UniversitiesEvent.loadMoreUniversities() =
      _LoadMoreUniversitiesEvent;
  const factory UniversitiesEvent.updateUniversity({
    required University university,
  }) = _UpdateUniversityEvent;
}
