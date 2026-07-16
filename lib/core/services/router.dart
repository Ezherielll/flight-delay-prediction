import 'package:flight_delay_predict/core/utils/app_toast.dart';
import 'package:flight_delay_predict/viewmodels/auth_viewmodel.dart';
import 'package:flight_delay_predict/views/admin/admin_panel_view.dart';
import 'package:flight_delay_predict/views/auth/login_view.dart';
import 'package:flight_delay_predict/views/auth/register_view.dart';
import 'package:flight_delay_predict/views/history/history_view.dart';
import 'package:flight_delay_predict/views/home/home_view.dart';
import 'package:flight_delay_predict/views/info/info_center_view.dart';
import 'package:flight_delay_predict/views/prediction/prediction_view.dart';
import 'package:flight_delay_predict/views/result/result_view.dart';
import 'package:flight_delay_predict/views/settings/settings_view.dart';
import 'package:flight_delay_predict/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: AppToast.navigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshNotifier(ref),
    redirect: (context, state) {
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

      // Admin route guard: redirect non-admin users to /home
      if (state.matchedLocation == '/admin' && !authState.isAdmin) {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginView();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterView();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: '/predict',
        builder: (context, state) {
          return const PredictionView();
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) {
          return const ResultView();
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) {
          return const HistoryView();
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) {
          return const SettingsView();
        },
      ),
      GoRoute(
        path: '/info',
        builder: (context, state) {
          return const InfoCenterView();
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          return const AdminPanelView();
        },
      ),
    ],
  );
});
