/// 投稿画面の状態
class ComposeState {
  const ComposeState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  ComposeState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return ComposeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
