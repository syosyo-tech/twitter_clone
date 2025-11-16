import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/entity/post.dart';
import 'package:poster/providers.dart';

/// 投稿詳細画面
class PostDetailView extends ConsumerWidget {
  const PostDetailView({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUseCase = ref.read(userUseCaseProvider);

    // タイムスタンプをフォーマット
    final createdDate =
        DateTime.fromMillisecondsSinceEpoch(post.createdAt * 1000);
    final formattedDate =
        '${createdDate.year}/${createdDate.month}/${createdDate.day} ${createdDate.hour}:${createdDate.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ポスト'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.lightBlueAccent,
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ユーザー情報
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(
                      Icons.egg,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _getUsername(userUseCase, post.userId),
                      builder: (context, snapshot) {
                        final username = snapshot.data ?? '@${post.usernameCache}';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 投稿内容
              Text(
                post.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // お気に入り情報
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final postUseCase = ref.read(postUseCaseProvider);
                      final isFavorited = !post.isFavorited;
                      await postUseCase.toggleFavorite(post.id, isFavorited);
                    },
                    child: Row(
                      children: [
                        Icon(
                          post.isFavorited ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${post.favorite} likes',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// UIDからユーザー名を取得するヘルパーメソッド
  Future<String> _getUsername(dynamic userUseCase, String userId) async {
    try {
      final user = await userUseCase.getUser(userId);
      return '@${user?.username ?? 'Unknown User'}';
    } catch (e) {
      return '@Unknown User';
    }
  }
}
