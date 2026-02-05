import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_test/features/universities/domain/entities/university.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_test/features/universities/presentation/bloc/universities_bloc.dart';
import 'package:frontend_test/injection_container.dart';

// Página de universidades
class UniversitiesPage extends StatelessWidget {
  const UniversitiesPage({super.key});

  bool _onScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      final limit = metrics.maxScrollExtent * 0.9; // 90% del scroll

      if (metrics.pixels >= limit) {
        context.read<UniversitiesBloc>().add(
          const UniversitiesEvent.loadMoreUniversities(),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<UniversitiesBloc>()
            ..add(const UniversitiesEvent.getUniversities()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Universidades'),
          actions: [
            BlocBuilder<UniversitiesBloc, UniversitiesState>(
              builder: (context, state) {
                final isGridView = state.maybeMap(
                  loaded: (s) => s.viewType == ViewType.grid,
                  orElse: () => false,
                );
                return IconButton(
                  icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    context.read<UniversitiesBloc>().add(
                      const UniversitiesEvent.toggleView(),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<UniversitiesBloc, UniversitiesState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Center(child: CircularProgressIndicator()),
              failed: (_) => const Center(child: Text('Error al cargar')),
              loaded: (state) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) =>
                      _onScrollNotification(notification, context),
                  child: state.viewType == ViewType.list
                      ? _buildListView(state.universities, state.hasMore)
                      : _buildGridView(state.universities, state.hasMore),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<University> universities, bool hasMore) {
    return ListView.builder(
      key: Key('list_view'),
      itemCount: universities.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= universities.length) {
          return _buildLoadingIndicator();
        }

        final university = universities[index];
        return ListTile(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${university.name} $index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (university.studentCount != null)
                    Text(
                      'Estudiantes: ${university.studentCount}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
          onTap: () async {
            final result = await context.pushNamed('university-detail', extra: university);
            if (result != null && result is Map<String, dynamic>) {
              // Actualizar la universidad con los nuevos datos
              context.read<UniversitiesBloc>().add(
                UniversitiesEvent.updateUniversity(
                  university: university.copyWith(
                    imagePath: result['imagePath'] as String?,
                    studentCount: result['studentCount'] as int?,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildGridView(List<University> universities, bool hasMore) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: universities.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= universities.length) {
          return _buildLoadingIndicator();
        }

        final university = universities[index];
        return GestureDetector(
          onTap: () async {
            final result = await context.pushNamed('university-detail', extra: university);
            if (result != null && result is Map<String, dynamic>) {
              // Actualizar la universidad con los nuevos datos
              context.read<UniversitiesBloc>().add(
                UniversitiesEvent.updateUniversity(
                  university: university.copyWith(
                    imagePath: result['imagePath'] as String?,
                    studentCount: result['studentCount'] as int?,
                  ),
                ),
              );
            }
          },
          child: Card(
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mostrar imagen si existe
                  if (university.imagePath != null)
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(university.imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      flex: 3,
                      child: Icon(
                        Icons.school,
                        size: 50,
                        color: Colors.white70,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          university.name ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (university.studentCount != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Estudiantes: ${university.studentCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
