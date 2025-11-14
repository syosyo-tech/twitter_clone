import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poster/providers.dart';

/// 投稿画面
class ComposeView extends ConsumerStatefulWidget {
  const ComposeView({super.key});

// Stateクラスを生成
  @override
  ConsumerState<ComposeView> createState() => _ComposeViewState();
}
// Stateクラス
class _ComposeViewState extends ConsumerState<ComposeView> {
  final TextEditingController _controller = TextEditingController();

// Stateの破棄時にコントローラーも破棄
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ViewModelの状態を監視
    final state = ref.watch(composeViewModelProvider);
    final viewModel = ref.read(composeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('つぶやく'),
        backgroundColor: Colors.lightBlueAccent,
        titleTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        // 戻るボタン
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '今なにしてる？',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // エラーメッセージの表示
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final text = _controller.text;
                      if (text.isNotEmpty) {
                        // ViewModelを経由して投稿を作成
                        await viewModel.createPost(text);

                        // 投稿後にタイムラインへ戻る
                        if (context.mounted && state.errorMessage == null) {
                          context.pop();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'ポスト',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
