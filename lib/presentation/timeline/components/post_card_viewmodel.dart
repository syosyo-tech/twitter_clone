import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/usecase/post_usecase.dart';
import 'package:poster/domain/usecase/user_usecase.dart';
import 'package:poster/presentation/timeline/components/post_card_state.dart';
import 'package:poster/providers.dart';

/// 投稿カードViewModel
class PostCardViewModel extends Notifier<PostCardState> {
  PostUseCase get _postUseCase => ref.read(postUseCaseProvider);
  UserUseCase get _userUseCase => ref.read(userUseCaseProvider);

  @override
  PostCardState build() {
    return PostCardState();
  }

  /// UIDからユーザー名を取得
  Future<String> getUsernameByUid(String userId) async {
    try {
      final user = await _userUseCase.getUser(userId);
      return user?.username ?? 'Unknown User';
    } catch (e) {
      return 'Unknown User';
    }
  }

  /// お気に入りの切り替え
  void toggleFavorite(String postId) {
    state.toggleFavorite();
    // ここでUseCaseを使ってお気に入り状態を更新する処理を呼び出すことができます
    _postUseCase.toggleFavorite(postId, state.isFavorited);
    // 状態の更新を通知
    state = PostCardState(isFavorited: state.isFavorited);
  }
} 