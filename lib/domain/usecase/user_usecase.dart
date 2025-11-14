import 'package:poster/domain/entity/user.dart';

/// ユーザー関連のUseCaseインターフェース
abstract class UserUseCase {
  /// ユーザーを作成
  Future<void> createUser({
    required String uid,
    required String email,
    required String username,
    String? bio,
    String? photoUrl,
  });

  /// ユーザー情報を取得
  Future<User?> getUser(String uid);

  /// ユーザー情報を更新
  Future<void> updateUser(String uid, Map<String, dynamic> data);

  /// ユーザーネームが既に存在するか確認
  Future<bool> isUsernameExists(String username);

  /// 現在のユーザー情報を取得
  Future<User?> getCurrentUser();
}
