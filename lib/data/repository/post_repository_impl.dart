import 'package:poster/data/datastore/post_datastore.dart';
import 'package:poster/domain/entity/post.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';
import 'package:poster/domain/usecase/post_usecase.dart';
import 'package:poster/domain/usecase/user_usecase.dart';

/// 投稿リポジトリの実装（PostUseCaseを実装）
class PostRepositoryImpl implements PostUseCase {
  PostRepositoryImpl({
    required PostDataStore dataStore,
    required AuthUseCase authUseCase,
    required UserUseCase userUseCase,
  })  : _dataStore = dataStore,
        _authUseCase = authUseCase,
        _userUseCase = userUseCase;

  final PostDataStore _dataStore;
  final AuthUseCase _authUseCase;
  final UserUseCase _userUseCase;

  @override
  Future<void> createPost({required String content}) async {
    // 現在のユーザー情報を取得
    final currentUser = await _userUseCase.getCurrentUser();
    if (currentUser == null) {
      throw Exception('ユーザーがログインしていません');
    }

    // IDの生成
    final createdAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final id = '${createdAt}_${content.hashCode}';

    // UIDとユーザー名を保存
    final userId = currentUser.uid;
    final usernameCache = currentUser.username;
    const sig = 'dummy_signature_456';

    // DataStore経由で投稿を作成
    await _dataStore.createPost(
      id: id,
      userId: userId,
      usernameCache: usernameCache,
      createdAt: createdAt,
      content: content,
      sig: sig,
    );
  }

  @override
  Stream<List<Post>> getTimelineStream({int limit = 50}) {
    final currentUserId = _authUseCase.getCurrentUserId();

    // ユーザーがログインしている場合は、お気に入り状態も取得
    if (currentUserId != null) {
      return _dataStore
          .getTimelineStreamWithFavorites(userId: currentUserId, limit: limit)
          .map((dataList) {
        return dataList.map((data) => _mapToEntity(data)).toList();
      });
    }

    // 未ログインの場合は通常のタイムライン
    return _dataStore.getTimelineStream(limit: limit).map((dataList) {
      return dataList.map((data) => _mapToEntity(data)).toList();
    });
  }

  @override
  Future<void> toggleFavorite(
    String postId,
    bool isFavorited ) async {
    final currentUserId = _authUseCase.getCurrentUserId();
    if (currentUserId == null) {
      throw Exception('ユーザーがログインしていません');
    }
    await _dataStore.toggleFavorite(postId, currentUserId);
  }

  /// Map からPostエンティティへ変換
  Post _mapToEntity(Map<String, dynamic> data) {
    return Post(
      id: data['id'] as String? ?? '',
      userId: data['user_id'] as String? ?? '',
      usernameCache: data['username_cache'] as String? ?? '',
      createdAt: data['created_at'] as int? ?? 0,
      content: data['content'] as String? ?? '',
      sig: data['sig'] as String? ?? '',
      favorite: data['favorite'] as int? ?? 0,
      isFavorited: data['isFavorited'] as bool? ?? false,
    );
  }
}
