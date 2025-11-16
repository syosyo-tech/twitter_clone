import 'package:poster/domain/entity/post.dart';

/// タイムライン画面の状態
class TimelineState {
  const TimelineState({
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Post> posts;
  final bool isLoading;
  final String? errorMessage;

  TimelineState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimelineState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
