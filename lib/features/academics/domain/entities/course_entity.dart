class CourseEntity {
  const CourseEntity({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
    required this.lecturer,
  });

  final String id;
  final String title;
  final String code;
  final String description;
  final String lecturer;
}
