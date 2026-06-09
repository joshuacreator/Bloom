import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_checker_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/password_reset_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/account_screen.dart';
import '../../features/profile/presentation/screens/theme_selector_screen.dart';
import '../../features/room/presentation/screens/room_chats_screen.dart';
import '../../features/room/presentation/screens/room_msg_screen.dart';
import '../../features/room/domain/entities/room_entity.dart';
import '../../features/room/presentation/screens/room_info_screen.dart';
import '../../features/room/presentation/screens/create_room_screen.dart';
import '../../features/room/presentation/screens/user_screen.dart';
import '../../features/space/domain/entities/space_entity.dart';
import '../../features/space/presentation/screens/space_info_screen.dart';
import '../../features/space/presentation/screens/discover_space_screen.dart';
import '../../features/space/presentation/screens/create_space_screen.dart';
import '../../features/space/presentation/screens/space_settings_screen.dart';
import '../../features/academics/presentation/screens/academics_home_screen.dart';
import '../../features/academics/presentation/screens/courses_screen.dart';
import '../../features/academics/presentation/screens/lectures_screen.dart';
import '../../features/academics/presentation/screens/courseworks_screen.dart';
import '../../features/academics/presentation/screens/performance_report_screen.dart';
import '../../features/academics/presentation/screens/events_screen.dart';
import '../../common/widgets/b_nav_bar.dart';

final goRouter = GoRouter(
  initialLocation: '/auth-checker',
  routes: [
    GoRoute(
      path: '/auth-checker',
      builder: (context, state) => const AuthCheckerScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) => const VerifyEmailScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const BNavBar(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: 'account',
              builder: (context, state) => const AccountScreen(),
            ),
            GoRoute(
              path: 'theme-selector',
              builder: (context, state) => const ThemeSelectorScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'rooms',
          builder: (context, state) => RoomChatsScreen(
            spaceId: state.extra as String?,
          ),
          routes: [
            GoRoute(
              path: 'room-msg/:spaceId',
              builder: (context, state) => RoomMsgScreen(
                room: state.extra as RoomEntity? ?? RoomEntity(name: '', creatorId: '', private: false, participants: const []),
                spaceId: state.pathParameters['spaceId']!,
              ),
              routes: [
                GoRoute(
                  path: 'room-info/:spaceId',
                  builder: (context, state) => RoomInfoScreen(
                    spaceId: state.pathParameters['spaceId']!,
                    room: state.extra as RoomEntity? ?? RoomEntity(name: '', creatorId: '', private: false, participants: const []),
                  ),
                  routes: [
                    GoRoute(
                      path: 'user/:userId',
                      builder: (context, state) => UserScreen(
                        userId: state.pathParameters['userId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'academics',
          builder: (context, state) => const AcademicsHomeScreen(),
          routes: [
            GoRoute(
              path: 'courses',
              builder: (context, state) => CoursesScreen(),
            ),
            GoRoute(
              path: 'lectures',
              builder: (context, state) => const LecturesScreen(),
            ),
            GoRoute(
              path: 'courseworks',
              builder: (context, state) => const CourseworksScreen(),
            ),
            GoRoute(
              path: 'performance',
              builder: (context, state) => const PerformanceReportScreen(),
            ),
            GoRoute(
              path: 'events',
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'create-space',
          builder: (context, state) => const CreateSpaceScreen(),
        ),
        GoRoute(
          path: 'discover',
          builder: (context, state) => const DiscoverSpacesScreen(),
        ),
        GoRoute(
          path: 'space-info',
          builder: (context, state) => SpaceInfoScreen(
            space: state.extra as SpaceEntity? ?? SpaceEntity(name: '', createdAt: DateTime.now(), private: false),
          ),
          routes: [
            GoRoute(
              path: 'space-settings',
              builder: (context, state) => SpaceSettingsScreen(
                space: state.extra as SpaceEntity? ?? SpaceEntity(name: '', createdAt: DateTime.now(), private: false),
              ),
            ),
            GoRoute(
              path: 'create-room/:spaceID',
              builder: (context, state) => CreateRoomScreen(
                spaceId: state.pathParameters['spaceID']!,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
