import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poster/domain/entity/user.dart';

/// ユーザーデータストア（Firestore通信）
class UserDataStore {
  UserDataStore({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// ユーザーコレクションの参照
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// ユーザーを作成
  Future<void> createUser(User user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  /// ユーザー情報を取得
  Future<User?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return User.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// ユーザー情報を更新
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  /// ユーザーネームが既に存在するか確認
  Future<bool> isUsernameExists(String username) async {
    final querySnapshot = await _usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
