import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../providers/firestore_provider.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/academics_repo.dart';
import '../../domain/usecases/add_course_use_case.dart';
import '../../domain/usecases/delete_course_use_case.dart';
import '../../domain/usecases/observe_courses_use_case.dart';
import '../../data/repositories/academics_repo_impl.dart';
import '../notifiers/academics_notifier.dart';

final academicsRepoProvider = Provider<AcademicsRepo>(
  (ref) => AcademicsRepoImpl(ref.watch(firestoreProvider)),
);

final observeCoursesUseCaseProvider = Provider<ObserveCoursesUseCase>(
  (ref) => ObserveCoursesUseCase(ref.watch(academicsRepoProvider)),
);

final addCourseUseCaseProvider = Provider<AddCourseUseCase>(
  (ref) => AddCourseUseCase(ref.watch(academicsRepoProvider)),
);

final deleteCourseUseCaseProvider = Provider<DeleteCourseUseCase>(
  (ref) => DeleteCourseUseCase(ref.watch(academicsRepoProvider)),
);

final academicsNotifierProvider =
    StateNotifierProvider<AcademicsNotifier, AsyncValue<List<CourseEntity>>>(
  (ref) => AcademicsNotifier(
    observeCoursesUseCase: ref.watch(observeCoursesUseCaseProvider),
    addCourseUseCase: ref.watch(addCourseUseCaseProvider),
    deleteCourseUseCase: ref.watch(deleteCourseUseCaseProvider),
  ),
);
