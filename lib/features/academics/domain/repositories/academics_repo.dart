import '../entities/course_entity.dart';

abstract class AcademicsRepo {
  Stream<List<CourseEntity>> observeCourses(String userId);

  Future<void> addCourse(CourseEntity course, String userId);

  Future<void> deleteCourse(String courseId, String userId);
}
