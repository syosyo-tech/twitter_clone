import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poster/presentation/auth/signup/signup_view.dart';
import 'package:poster/presentation/auth/signin/signin_view.dart';
import 'package:poster/presentation/compose/compose_view.dart';
import 'package:poster/presentation/main_tab_view.dart';
import 'package:poster/presentation/profile/profile_view.dart';
import 'package:poster/presentation/profile/edit_profile_view.dart';

final router = GoRouter(
  routes: [
    // サインアップページ（初期画面）
    GoRoute(
      path: '/',
      builder: (context, state) => const SignUpView(),
    ),

    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInView(), 
    ),

    // タイムラインページ（ホーム画面）
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainTabView(),
    ),

    // 投稿作成ページ（左右スライドアニメーション付き）
    GoRoute(
      path: '/compose',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ComposeView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;

            // push: 右→左、pop: 左→右 の両方向アニメーション
            final enterFromRight = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            final exitToRight = Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(enterFromRight),
              child: SlideTransition(
                position: secondaryAnimation.drive(exitToRight),
                child: child,
              ),
            );
          },
        );
      },
    ),

    // プロフィールページ
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),

    // プロフィール編集ページ
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileView(),
    ),
  ],
);