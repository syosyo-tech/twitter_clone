import 'package:cloud_firestore/cloud_firestore.dart';

/// 投稿データストア（Firestore通信）
class PostDataStore {
  PostDataStore({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// 投稿コレクションの参照
  CollectionReference get _postsCollection => _firestore.collection('posts');

  /// 投稿を作成
  Future<void> createPost({
    required String id,
    required String userId,
    required String usernameCache,
    required int createdAt,
    required String content,
    required String sig,
  }) async {
    await _postsCollection.doc(id).set({
      'id': id,
      'user_id': userId, // UIDを保存（ユーザー名ではなく）
      'username_cache': usernameCache, // ユーザー名のキャッシュ
      'created_at': createdAt,
      'content': content,
      'sig': sig,
      'favorite': 0, // お気に入り数を0で初期化
    });
  }

  /// お気に入りをトグル（追加/削除）
  Future<void> toggleFavorite(String postId, String userId) async {
    final favoriteDoc = _postsCollection
        .doc(postId)
        .collection('favorites')
        .doc(userId);

    final snapshot = await favoriteDoc.get();

    if (snapshot.exists) {
      // すでにお気に入り登録済み → 削除
      await favoriteDoc.delete();
      await _postsCollection.doc(postId).update({
        'favorite': FieldValue.increment(-1),
      });
    } else {
      // 未登録 → 追加
      await favoriteDoc.set({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _postsCollection.doc(postId).update({
        'favorite': FieldValue.increment(1),
      });
    }
  }

  /// ユーザーがお気に入り登録しているか確認
  Future<bool> isFavorited(String postId, String userId) async {
    final snapshot = await _postsCollection
        .doc(postId)
        .collection('favorites')
        .doc(userId)
        .get();
    return snapshot.exists;
  }

  /// タイムライン取得時に現在のユーザーのお気に入り状態も取得
  Stream<List<Map<String, dynamic>>> getTimelineStreamWithFavorites({
    required String userId,
    int limit = 50,
  }) {
    return _postsCollection
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      final posts = <Map<String, dynamic>>[];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final isFav = await isFavorited(doc.id, userId);
        data['isFavorited'] = isFav;
        posts.add(data);
      }
      return posts;
    });
  }

  /// タイムライン を取得（リアルタイム）
  Stream<List<Map<String, dynamic>>> getTimelineStream({int limit = 50}) {
    return _postsCollection
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  /// タイムラインを取得（一度だけ）
  Future<List<Map<String, dynamic>>> getTimeline({int limit = 50}) async {
    final snapshot = await _postsCollection
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
  }
}
