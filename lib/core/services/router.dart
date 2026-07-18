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
        pageBuilder: (context, state) => _buildFadePage(
          context,
          state,
          const SplashView(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildBottomSlidePage(
          context,
          state,
          const LoginView(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _buildBottomSlidePage(
          context,
          state,
          const RegisterView(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _buildFadePage(
          context,
          state,
          const HomeView(),
        ),
      ),
      GoRoute(
        path: '/predict',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const PredictionView(),
        ),
      ),
      GoRoute(
        path: '/result',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const ResultView(),
        ),
      ),
      GoRoute(
        path: '/history',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const HistoryView(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const SettingsView(),
        ),
      ),
      GoRoute(
        path: '/info',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const InfoCenterView(),
        ),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => _buildSlidePage(
          context,
          state,
          const AdminPanelView(),
        ),
      ),
    ],
  );
});

CustomTransitionPage<void> _buildFadePage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _buildSlidePage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _buildBottomSlidePage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      );
    },
  );
}
