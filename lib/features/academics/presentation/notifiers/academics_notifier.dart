import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/add_course_use_case.dart';
import '../../domain/usecases/delete_course_use_case.dart';
import '../../domain/usecases/observe_courses_use_case.dart';

class AcademicsNotifier
    extends StateNotifier<AsyncValue<List<CourseEntity>>> {
  AcademicsNotifier({
    required this.observeCoursesUseCase,
    required this.addCourseUseCase,
    required this.deleteCourseUseCase,
  }) : super(const AsyncValue.loading());

  final ObserveCoursesUseCase observeCoursesUseCase;
  final AddCourseUseCase addCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;
  String? _userId;
  StreamSubscription<List<CourseEntity>>? _subscription;

  void observe(String userId) {
    if (_userId == userId) return;
    _userId = userId;
    _subscription?.cancel();
    state = const AsyncValue.loading();
    _subscription = observeCoursesUseCase(userId).listen(
      (courses) => state = AsyncValue.data(courses),
      onError: (error, stackTrace) =>
          state = AsyncValue.error(error, stackTrace),
    );
  }

  Future<void> add(CourseEntity course) async {
    if (_userId == null) return;
    try {
      await addCourseUseCase(course, _userId!);
    } catch (_) {}
  }

  Future<void> delete(String courseId) async {
    if (_userId == null) return;
    try {
      await deleteCourseUseCase(courseId, _userId!);
    } catch (_) {}
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
