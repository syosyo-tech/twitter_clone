import 'package:firebase_auth/firebase_auth.dart';

/// 認証ユースケースのインターフェース
abstract class AuthUseCase {
  /// 匿名ログイン
  Future<User?> signInAnonymously();

  /// ユーザー登録
  Future<User?> signUp(String email, String password);

  /// ログイン
  Future<User?> signIn(String email, String password);

  /// ログアウト
  Future<void> signOut();

  /// 現在のユーザー情報を取得
  User? getCurrentUser();

  /// 現在のユーザーIDを取得
  String? getCurrentUserId();
}