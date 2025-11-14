// postcardの状態を管理するためのStateクラス
class PostCardState {
  bool isFavorited;

  PostCardState({this.isFavorited = false});

  void toggleFavorite() {
    isFavorited = !isFavorited;
  }

  PostCardState copyWith({bool? isFavorited}) {
    return PostCardState(
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
