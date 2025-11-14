import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/usecase/post_usecase.dart';
import 'package:poster/presentation/compose/compose_state.dart';
// PostUseCaseProviderをインポートするためのダミー宣言（providers.dartで実際に定義）
import 'package:poster/providers.dart';

/// 投稿ViewModel
class ComposeViewModel extends Notifier<ComposeState> {
  PostUseCase get _useCase => ref.read(postUseCaseProvider);

  @override
  ComposeState build() {
    return const ComposeState();
  }

  /// 投稿を作成
  Future<void> createPost(String content) async {
    state = state.copyWith(isLoading: true);

    try {
      await _useCase.createPost(content: content);
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
