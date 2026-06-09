import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/connection_state.dart';
import '../../../../common/widgets/loading_indicator.dart';
import '../../../../common/widgets/snack_bar.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/academics_providers.dart';
import '../widgets/add_course_dialogue.dart';
import '../widgets/course_card.dart';
import '../widgets/course_details_dialogue.dart';

class CoursesScreen extends ConsumerWidget {
  static String id = 'courses';

  CoursesScreen({super.key});

  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseDescController = TextEditingController();
  final TextEditingController courseLecturerController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(academicsNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            onPressed: () async {
              final bool online = await isOnline();
              if (!online) {
                if (context.mounted) {
                  showSnackBar(
                    context,
                    msg:
                        "You're offline! Turn on wifi or mobile data to continue.",
                  );
                }
                return;
              }
              if (context.mounted) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddCourseDialogue(
                      titleController: courseTitleController,
                      codeController: courseCodeController,
                      descController: courseDescController,
                      lecturerController: courseLecturerController,
                      onAdd: () {
                        final notifier =
                            ref.read(academicsNotifierProvider.notifier);
                        notifier.add(
                          CourseEntity(
                            id: '',
                            title: courseTitleController.text.trim(),
                            code: courseCodeController.text.trim(),
                            description: courseDescController.text.trim(),
                            lecturer: courseLecturerController.text.trim(),
                          ),
                        );
                        context.pop();
                      },
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add course',
          ),
        ],
      ),
      body: courses.when(
        data: (data) {
          return data.isEmpty
              ? const Center(child: Text('Manage your semester courses here'))
              : ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final course = data[index];
                    return CourseCard(
                      title: course.title,
                      code: course.code,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return CourseDetailsDialogue(
                              id: course.id,
                              title: course.title,
                              code: course.code,
                              desc: course.description,
                              lecturer: course.lecturer,
                              onDelete: () {
                                final notifier =
                                    ref.read(academicsNotifierProvider.notifier);
                                notifier.delete(course.id);
                                context.pop();
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
        },
        error: (error, stackTrace) {
          return const Center(child: Text('An error occurred'));
        },
        loading: () => const Center(child: LoadingIndicator()),
      ),
    );
  }
}
