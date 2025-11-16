import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poster/providers.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);

    // 初回読み込み（初期状態でisLoading: trueの場合のみ）
    if (state.user == null && state.isLoading && state.errorMessage == null) {
      Future.microtask(() => viewModel.loadProfile());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('プロフィール'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : state.user == null
                  ? const Center(child: Text('ユーザー情報が見つかりません'))
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(),
                          // アイコンとユーザーネーム
                          Row(
                            children: [
                              // サークルアイコン
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(
                                  Icons.egg,
                                  color: Colors.white,
                                  size: 50,
                                  )
                              ),
                              const SizedBox(width: 16),
                              // ユーザーネーム
                              Expanded(
                                child: Text(
                                  '@${state.user!.username}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          // 自己紹介文
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              state.user!.bio ?? '自己紹介文がありません',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // 編集ボタン
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/profile/edit');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                              ),
                              child: const Text(
                                'プロフィールを編集',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
