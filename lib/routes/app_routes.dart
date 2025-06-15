import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/palace_creation_studio/palace_creation_studio.dart';
import '../presentation/palace_dashboard/palace_dashboard.dart';
import '../presentation/learning_archive/learning_archive.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/palace_review_session/palace_review_session.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String palaceDashboard = '/palace-dashboard';
  static const String palaceCreationStudio = '/palace-creation-studio';
  static const String palaceReviewSession = '/palace-review-session';
  static const String learningArchive = '/learning-archive';
  static const String userProfileSettings = '/user-profile-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    onboardingFlow: (context) => const OnboardingFlow(),
    palaceDashboard: (context) => const PalaceDashboard(),
    palaceCreationStudio: (context) => const PalaceCreationStudio(),
    palaceReviewSession: (context) => const PalaceReviewSession(),
    learningArchive: (context) => const LearningArchive(),
    userProfileSettings: (context) => const UserProfileSettings(),
  };
}
