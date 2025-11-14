import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poster/providers.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _emailController = TextEditingController();
    _isInitialized = false;

    // 初回読み込み
    Future.microtask(() {
      ref.read(editProfileViewModelProvider.notifier).loadCurrentProfile();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileViewModelProvider);
    final viewModel = ref.read(editProfileViewModelProvider.notifier);

    // 状態が更新されたときにcontrollerに反映
    ref.listen(editProfileViewModelProvider, (previous, next) {
      // 初回データ読み込み完了時にcontrollerを更新
      if (!_isInitialized && next.username.isNotEmpty && !next.isLoading) {
        _usernameController.text = next.username;
        _bioController.text = next.bio;
        _emailController.text = next.email;
        _isInitialized = true;
      }

      // 更新成功時にプロフィール画面に戻る
      if (next.success) {
        // プロフィール画面を再読み込み
        ref.invalidate(profileViewModelProvider);
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('プロフィールを更新しました'),
            backgroundColor: Colors.orangeAccent,),
        );
      }
    });

    if (state.isLoading && state.username.isEmpty) {
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('プロフィール編集'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
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

            // ユーザーネーム入力
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'ユーザーネーム',
                border: OutlineInputBorder(),
                hintText: '例: taro_yamada',
              ),
              onChanged: (value) {
                viewModel.setUsername(value);
              },
            ),
            const SizedBox(height: 16),

            // 自己紹介文入力
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: '自己紹介',
                border: OutlineInputBorder(),
                hintText: '自己紹介を入力してください',
              ),
              maxLines: 4,
              onChanged: (value) {
                viewModel.setBio(value);
              },
            ),
            const SizedBox(height: 16),

            // メールアドレス入力
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                viewModel.setEmail(value);
              },
            ),
            const SizedBox(height: 24),

            // 保存ボタン
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        viewModel.updateProfile();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
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
