import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/providers.dart';
import 'package:go_router/go_router.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  // providerからstateとviewmodelを取得
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelの状態を監視
    final state = ref.watch(signinViewModelProvider);
    // ViewModelの操作用インスタンスを取得
    final viewModel = ref.read(signinViewModelProvider.notifier);

    // successがtrueならホーム画面へ遷移
    ref.listen(signinViewModelProvider, (previous, next) {
      if (next.success) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('サインイン'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // エラーメッセージ表示
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // メールアドレス入力
            TextField(
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                viewModel.setEmail(value);
              },
            ),
            const SizedBox(height: 16),
            // パスワード入力
            TextField(
              decoration: const InputDecoration(
                labelText: 'パスワード',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) {
                viewModel.setPassword(value);
              },
            ),
            const SizedBox(height: 24),
            // サインアップボタン
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        viewModel.signin(state.email, state.password);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'サインイン',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
