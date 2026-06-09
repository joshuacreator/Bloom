import '../entities/course_entity.dart';
import '../repositories/academics_repo.dart';

class AddCourseUseCase {
  const AddCourseUseCase(this.repo);

  final AcademicsRepo repo;

  Future<void> call(CourseEntity course, String userId) =>
      repo.addCourse(course, userId);
}
