import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/entity/post.dart';
import 'package:poster/presentation/post_detail/post_detail_view.dart';
import 'package:poster/providers.dart';

/// 投稿カードコンポーネント
class PostCard extends ConsumerWidget {
  const PostCard({
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
        '${createdDate.hour}:${createdDate.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          // 投稿詳細画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailView(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar（プロフィールアイコン）
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orangeAccent,
              child: Icon(
                Icons.egg,
                color: Colors.white,
                size: 30,
                )
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // UIDから最新のユーザー名を取得して表示
                      FutureBuilder<String>(
                        future: _getUsername(userUseCase, post.userId),
                        builder: (context, snapshot) {
                          // ローディング中はキャッシュされたユーザー名を表示
                          final username = snapshot.data ?? '@${post.usernameCache}';
                          return Text(
                            username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Text(
                        // 投稿時刻を表示
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // 投稿内容
                    post.content,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          // お気に入りをトグル
                          final postUseCase = ref.read(postUseCaseProvider);
                          final isFavorited = !post.isFavorited;
                          await postUseCase.toggleFavorite(post.id, isFavorited);
                          if (isFavorited)
                            print('💩お気に入り登録');
                          else
                            print('💩お気に入り解除');
                        },
                        child: Row(
                          children: [
                            Icon(
                              post.isFavorited ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.favorite.toString(),
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
