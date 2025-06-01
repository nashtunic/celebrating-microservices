import 'package:flutter/material.dart';

import 'package:celebrate/AuthService.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateAfterLogin(
      BuildContext context, String role) async {
    switch (role.toLowerCase()) {
      case 'celebrity':
        await Navigator.pushReplacementNamed(
            context, '/celebrityprofilemanagement');
        break;
      case 'user':
        await Navigator.pushReplacementNamed(context, '/home');
        break;
      default:
        await Navigator.pushReplacementNamed(context, '/home');
    }
  }

  static Future<void> navigateToProfile(
      BuildContext context, String role) async {
    if (role.toLowerCase() == 'celebrity') {
      await Navigator.pushNamed(context, '/celebrityprofilemanagement');
    } else {
      await Navigator.pushNamed(context, '/userprofile');
    }
  }

  static Future<void> navigateToFeed(BuildContext context, String role) async {
    if (role.toLowerCase() == 'celebrity') {
      await Navigator.pushNamed(context, '/celebrityfeed');
    } else {
      await Navigator.pushNamed(context, '/home');
    }
  }

  static Future<void> navigateToPostCreation(BuildContext context) async {
    await Navigator.pushNamed(context, '/postcreation');
  }

  static Future<void> navigateToNotifications(BuildContext context) async {
    await Navigator.pushNamed(context, '/notifications');
  }

  static Future<void> navigateToCompare(BuildContext context) async {
    await Navigator.pushNamed(context, '/compare');
  }

  static Future<void> logout(BuildContext context) async {
    await AuthService.clearToken();
    await Navigator.pushNamedAndRemoveUntil(
        context, '/login', (route) => false);
  }
}
