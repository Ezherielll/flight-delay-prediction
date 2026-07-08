import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../views/splash/splash_view.dart';
import '../../views/home/home_view.dart';
import '../../views/prediction/prediction_view.dart';
import '../../views/result/result_view.dart';
import '../../views/history/history_view.dart';
import '../../views/settings/settings_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
    ),
    GoRoute(
      path: '/predict',
      builder: (BuildContext context, GoRouterState state) {
        return const PredictionView();
      },
    ),
    GoRoute(
      path: '/result',
      builder: (BuildContext context, GoRouterState state) {
        return const ResultView();
      },
    ),
    GoRoute(
      path: '/history',
      builder: (BuildContext context, GoRouterState state) {
        return const HistoryView();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsView();
      },
    ),
  ],
);
