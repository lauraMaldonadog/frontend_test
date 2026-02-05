import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend_test/core/const/const.dart';
import 'package:frontend_test/core/either/either.dart';
import 'package:frontend_test/features/universities/domain/repositories/universities_repository.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';

part 'universities_bloc.freezed.dart';
part 'universities_event.dart';
part 'universities_state.dart';

// Bloc de universidades
class UniversitiesBloc extends Bloc<UniversitiesEvent, UniversitiesState> {
  UniversitiesBloc({required this.universitiesRepository})
    : super(const UniversitiesState.loading()) {
    on<_GetUniversitiesEvent>(_getUniversities);
    on<_ToggleViewEvent>(_toggleView);
    on<_LoadMoreUniversitiesEvent>(_loadMoreUniversities);
    on<_UpdateUniversityEvent>(_updateUniversity);
  }

  final UniversitiesRepository universitiesRepository;

  // Obtener universidades
  Future<void> _getUniversities(
    _GetUniversitiesEvent event,
    Emitter<UniversitiesState> emit,
  ) async {
    final result = await universitiesRepository.getUniversities();
    result.when(
      left: (_) => emit(const _Failed()),
      right: (allUniversities) {
        final initialUniversities = allUniversities
            .take(Const.pageSize)
            .toList();

        emit(
          _Loaded(
            universities: initialUniversities,
            allUniversities: allUniversities,
            hasMore: allUniversities.length > Const.pageSize,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  // Cargar más universidades
  Future<void> _loadMoreUniversities(
    _LoadMoreUniversitiesEvent event,
    Emitter<UniversitiesState> emit,
  ) async {
    await state.mapOrNull(
      loaded: (loadedState) async {
        if (loadedState.isLoadingMore || !loadedState.hasMore) return;

        emit(loadedState.copyWith(isLoadingMore: true));

        final currentLength = loadedState.universities.length;
        final newUniversities = loadedState.allUniversities
            .skip(currentLength)
            .take(Const.pageSize)
            .toList();

        final updatedUniversities = [
          ...loadedState.universities,
          ...newUniversities,
        ];

        emit(
          loadedState.copyWith(
            universities: updatedUniversities,
            hasMore:
                updatedUniversities.length < loadedState.allUniversities.length,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  // Cambiar vista
  void _toggleView(_ToggleViewEvent event, Emitter<UniversitiesState> emit) {
    state.mapOrNull(
      loaded: (state) {
        final newViewType = state.viewType == ViewType.list
            ? ViewType.grid
            : ViewType.list;
        emit(state.copyWith(viewType: newViewType));
      },
    );
  }

  // Actualizar universidad
  void _updateUniversity(
    _UpdateUniversityEvent event,
    Emitter<UniversitiesState> emit,
  ) {
    state.mapOrNull(
      loaded: (loadedState) {
        // Actualizar la universidad en la lista de universidades mostradas
        final updatedUniversities = loadedState.universities.map((university) {
          if (university.name == event.university.name &&
              university.country == event.university.country) {
            return event.university;
          }
          return university;
        }).toList();

        // Actualizar la universidad en la lista completa
        final updatedAllUniversities = loadedState.allUniversities.map((
          university,
        ) {
          if (university.name == event.university.name &&
              university.country == event.university.country) {
            return event.university;
          }
          return university;
        }).toList();

        emit(
          loadedState.copyWith(
            universities: updatedUniversities,
            allUniversities: updatedAllUniversities,
          ),
        );
      },
    );
  }
}
