// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use


import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:linktree_clone/main.dart';
import 'package:linktree_clone/views/auth/ForgotPasswordPage.dart';
import 'package:linktree_clone/views/edit_link_screen.dart';
import '../views/add_link_screen.dart';
import '../views/auth/ResetPasswordPage.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_screen.dart';
import 'package:linktree_clone/models/Link.dart';


class AppRouter{
  GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            return HomeScreen();
          },

          routes: [
            GoRoute(
              path: 'addlink',
              name: 'addlink',
              builder: (context, state) {
                return AddLinkScreen();
              },
            ),
            GoRoute(
              path: 'editlink/:name/:url',
              name: 'editlink',
              builder: (context, state) {
                Link url = Link(state.params['name']!, state.params['url']!,);
                return EditLinkScreen(url: url);
              },
            ),

            GoRoute(
              path: 'profile',
              name: 'profile',
              builder: (context, state) {
                return const ProfileScreen();
              },
            ),
          ]
      ),

      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: '/forgotpassword',
        name: 'forgotpassword',
        builder: (context, state) {
          return  ForgotPasswordPage(userPool: userPool);
        },
      ),
    ],

  );
}
