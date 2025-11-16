import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/usecase/post_usecase.dart';
import 'package:poster/presentation/timeline/timeline_state.dart';
import 'package:poster/providers.dart';

/// タイムラインViewModel
class TimelineViewModel extends Notifier<TimelineState> {
  PostUseCase get _useCase => ref.read(postUseCaseProvider);
  StreamSubscription? _subscription;

  @override
  TimelineState build() {
    // 初期化時にタイムラインを購読開始
    _subscription?.cancel();
    _subscription = _useCase.getTimelineStream().listen(
      (posts) {
        state = state.copyWith(
          posts: posts,
          isLoading: false,
          errorMessage: null,
        );
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );

    // dispose時の処理
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // 初期状態を返す（ローディング中）
    return const TimelineState(isLoading: true);
  }

  /// タイムラインをリアルタイムで購読
  void _subscribeTimeline() {
    state = state.copyWith(isLoading: true);

    _subscription?.cancel();
    _subscription = _useCase.getTimelineStream().listen(
      (posts) {
        state = state.copyWith(
          posts: posts,
          isLoading: false,
          errorMessage: null,
        );
      },
      onError: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        );
      },
    );
  }

  /// タイムラインを手動で更新
  void refreshTimeline() {
    _subscribeTimeline();
  }
}
