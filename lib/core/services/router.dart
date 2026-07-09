import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../views/splash/splash_view.dart';
import '../../views/home/home_view.dart';
import '../../views/prediction/prediction_view.dart';
import '../../views/result/result_view.dart';
import '../../views/history/history_view.dart';
import '../../views/settings/settings_view.dart';
import '../../views/info/info_center_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/register_view.dart';
import '../../viewmodels/auth_viewmodel.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  final Ref ref;

  GoRouterRefreshNotifier(this.ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshNotifier(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);

      final loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!authState.isAuthenticated) {
        if (state.matchedLocation == '/' || loggingIn) {
          return null;
        }
        return '/login';
      }

      if (loggingIn) {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterView();
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
      GoRoute(
        path: '/info',
        builder: (BuildContext context, GoRouterState state) {
          return const InfoCenterView();
        },
      ),
    ],
  );
});
