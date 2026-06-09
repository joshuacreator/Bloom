import '../entities/course_entity.dart';
import '../repositories/academics_repo.dart';

class ObserveCoursesUseCase {
  const ObserveCoursesUseCase(this.repo);

  final AcademicsRepo repo;

  Stream<List<CourseEntity>> call(String userId) =>
      repo.observeCourses(userId);
}
