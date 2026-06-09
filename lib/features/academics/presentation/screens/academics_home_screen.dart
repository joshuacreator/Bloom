import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/users_providers.dart';
import '../../../../common/widgets/b_nav_bar.dart';
import '../widgets/activity_card.dart';
import '../widgets/profile_card.dart';
import 'courses_screen.dart';
import 'courseworks_screen.dart';
import 'events_screen.dart';
import 'lectures_screen.dart';
import 'performance_report_screen.dart';
import '../providers/academics_providers.dart';

class AcademicsHomeScreen extends ConsumerWidget {
  static String id = 'academics-home';

  const AcademicsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    final userId = ref.watch(authStateProvider).value?.uid;
    if (userId != null) {
      ref.watch(academicsNotifierProvider.notifier).observe(userId);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Academics')),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          ProfileCard(
            studentId: user?['studentId'] ?? 'N/A',
            name: user?['name'] ?? 'N/A',
            intake: (user?['isStaff'] ?? false)
                ? 'Staff'
                : user?['intake'] == null
                    ? 'N/A'
                    : '${DateFormat('MMM yyyy').format((user?['intake']).toDate())} intake',
            image: user?['image'] ?? AppConstants.defaultUserImgPath,
          ),
          const Gap(20.0),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            children: [
              ActivityCard(
                icon: const Icon(Icons.school_rounded, size: 55),
                title: 'Courses',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${CoursesScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.schedule_rounded, size: 55),
                title: 'Lectures',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${LecturesScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.assignment_rounded, size: 55),
                title: 'Courseworks',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${CourseworksScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.assessment_rounded, size: 55),
                title: 'Performance/Report',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${PerformanceReportScreen.id}',
                  );
                },
              ),
              ActivityCard(
                icon: const Icon(Icons.event_rounded, size: 55),
                title: 'Events',
                onTap: () {
                  context.push(
                    '${BNavBar.id}/${AcademicsHomeScreen.id}/${EventsScreen.id}',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
