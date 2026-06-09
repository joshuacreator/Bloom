import '../repositories/academics_repo.dart';

class DeleteCourseUseCase {
  const DeleteCourseUseCase(this.repo);

  final AcademicsRepo repo;

  Future<void> call(String courseId, String userId) =>
      repo.deleteCourse(courseId, userId);
}
