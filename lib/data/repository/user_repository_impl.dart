import 'package:poster/data/datastore/user_datastore.dart';
import 'package:poster/domain/entity/user.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';
import 'package:poster/domain/usecase/user_usecase.dart';

/// ユーザーリポジトリの実装（UserUseCaseを実装）
class UserRepositoryImpl implements UserUseCase {
  UserRepositoryImpl({
    required UserDataStore dataStore,
    required AuthUseCase authUseCase,
  })  : _dataStore = dataStore,
        _authUseCase = authUseCase;

  final UserDataStore _dataStore;
  final AuthUseCase _authUseCase;

  @override
  Future<void> createUser({
    required String uid,
    required String email,
    required String username,
    String? bio,
    String? photoUrl,
  }) async {
    final user = User(
      uid: uid,
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    await _dataStore.createUser(user);
  }

  @override
  Future<User?> getUser(String uid) async {
    return await _dataStore.getUser(uid);
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _dataStore.updateUser(uid, data);
  }

  @override
  Future<bool> isUsernameExists(String username) async {
    return await _dataStore.isUsernameExists(username);
  }

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _authUseCase.getCurrentUser();
    if (firebaseUser == null) {
      return null;
    }
    return await getUser(firebaseUser.uid);
  }
}
