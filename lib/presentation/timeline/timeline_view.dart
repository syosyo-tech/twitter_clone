import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poster/presentation/timeline/components/post_card.dart';
import 'package:poster/providers.dart';

/// タイムライン画面
class TimelineView extends ConsumerWidget {
  const TimelineView({super.key});

// providerからstateとviewmodelを取得
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModelの状態を監視
    final state = ref.watch(timelineViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: const Icon(
          Icons.flutter_dash,
          color: Colors.white,
          size: 45,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(timelineViewModelProvider.notifier).refreshTimeline();
        },
        child: _buildBody(state),
      ),
      // 追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 投稿ページへ遷移（pushを使うことでpopできるようにする）
          context.push('/compose');
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 画面本体を構築
  Widget _buildBody(state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text('エラー: ${state.errorMessage}'));
    }

    if (state.posts.isEmpty) {
      return const Center(child: Text('投稿がありません'));
    }

    return ListView.builder(
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return PostCard(post: post);
      },
    );
  }
}
