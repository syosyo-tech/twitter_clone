import 'package:poster/domain/entity/post.dart';

/// 投稿関連のUseCaseインターフェース
abstract class PostUseCase {
  /// 投稿を作成
  Future<void> createPost({
    required String content,
  });

  /// タイムラインを取得（Stream）
  Stream<List<Post>> getTimelineStream({int limit = 50});

  /// お気に入りをトグル（追加/削除）
  Future<void> toggleFavorite(
    String postId,
    bool isFavorited
  );
}
