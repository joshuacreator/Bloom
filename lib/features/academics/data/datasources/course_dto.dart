import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/course_entity.dart';

class CourseDto {
  const CourseDto({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.lecturer,
  });

  factory CourseDto.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseDto(
      id: doc.id,
      title: data['title'] as String? ?? '',
      code: data['code'] as String? ?? '',
      description: data['desc'] as String? ?? '',
      lecturer: data['lecturer'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String code;
  final String description;
  final String lecturer;

  CourseEntity toDomain() => CourseEntity(
        id: id,
        title: title,
        code: code,
        description: description,
        lecturer: lecturer,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'code': code,
        'desc': description,
        'lecturer': lecturer,
      };
}
