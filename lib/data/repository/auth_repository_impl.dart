import 'package:firebase_auth/firebase_auth.dart';
import 'package:poster/data/datastore/auth_datastore.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';

/// 認証リポジトリの実装（AuthUseCaseを実装）
class AuthRepositoryImpl implements AuthUseCase {
  AuthRepositoryImpl({
    required AuthDataStore dataStore,
  }) : _dataStore = dataStore;

  final AuthDataStore _dataStore;

  @override
  Future<User?> signInAnonymously() async {
    return await _dataStore.signInAnonymously();
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return await _dataStore.signUp(email, password);
  }

  @override
  Future<User?> signIn(String email, String password) async {
    return await _dataStore.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await _dataStore.signOut();
  }

  @override
  User? getCurrentUser() {
    return _dataStore.getCurrentUser();
  }

  @override
  String? getCurrentUserId() {
    // Firebase AuthのUIDを返す
    final user = _dataStore.getCurrentUser();
    return user?.uid;
  }
}