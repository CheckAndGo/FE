import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/checklist/checklist_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/templates/templates_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/not_found_screen.dart';
import '../models/trip.dart';

final appRouter = GoRouter(
  initialLocation: '/auth/welcome',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/calendar',
      builder: (context, state) {
        final Trip? newTrip = state.extra as Trip?;
        return CalendarScreen(newTrip: newTrip);
      },
    ),

    GoRoute(
      path: '/checklist',
      builder: (context, state) => const ChecklistScreen(),
    ),
    GoRoute(
      path: '/checklist/:tripId',
      builder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        return ChecklistScreen(tripId: tripId);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/templates',
      builder: (context, state) => const TemplatesScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/auth/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
