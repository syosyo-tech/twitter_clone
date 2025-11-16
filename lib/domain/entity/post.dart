/// 投稿エンティティ
class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.usernameCache,
    required this.createdAt,
    required this.content,
    required this.sig,
    required this.favorite,
    this.isFavorited = false,
  });

  final String id;
  final String userId; // ユーザーのUID（Firebaseから最新のユーザー名を取得するために使用）
  final String usernameCache; // 投稿時のユーザー名キャッシュ（ローディング中に表示）
  final int createdAt;
  final String content;
  final String sig;
  final int favorite;
  final bool isFavorited;
}
