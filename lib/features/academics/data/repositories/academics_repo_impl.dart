import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/academics_repo.dart';
import '../datasources/course_dto.dart';

class AcademicsRepoImpl implements AcademicsRepo {
  const AcademicsRepoImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Stream<List<CourseEntity>> observeCourses(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('courses')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CourseDto.fromSnapshot(doc).toDomain())
              .toList(),
        );
  }

  @override
  Future<void> addCourse(CourseEntity course, String userId) async {
    final dto = CourseDto(
      id: '',
      title: course.title,
      code: course.code,
      description: course.description,
      lecturer: course.lecturer,
    );
    await firestore
        .collection('users')
        .doc(userId)
        .collection('courses')
        .add(dto.toMap());
  }

  @override
  Future<void> deleteCourse(String courseId, String userId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .delete();
  }
}
