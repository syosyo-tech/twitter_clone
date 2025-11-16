import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';
import 'package:poster/domain/usecase/user_usecase.dart';
import 'package:poster/presentation/auth/signup/signup_state.dart';
import 'package:poster/providers.dart';

class SignupViewModel extends Notifier<SignupState> {
  AuthUseCase get _authUseCase => ref.read(authUseCaseProvider);
  UserUseCase get _userUseCase => ref.read(userUseCaseProvider);

  @override
  SignupState build() {
    return const SignupState();
  }

  // viewからemailを受け取る
  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  // passwordを受け取る
  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  // usernameを受け取る
  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  /// サインアップを実行
  Future<void> signup(String email, String password, String username) async {
    state = state.copyWith(isLoading: true);

    try {
      // バリデーション
      if (username.isEmpty) {
        throw Exception('ユーザーネームを入力してください');
      }

      // ユーザーネームの重複チェック
      final exists = await _userUseCase.isUsernameExists(username);
      if (exists) {
        throw Exception('このユーザーネームは既に使用されています');
      }

      // Firebase Authでユーザー作成
      final firebaseUser = await _authUseCase.signUp(email, password);
      if (firebaseUser == null) {
        throw Exception('ユーザーの作成に失敗しました');
      }

      // Firestoreにユーザー情報を保存
      await _userUseCase.createUser(
        uid: firebaseUser.uid,
        email: email,
        username: username,
      );

      state = state.copyWith(
        isLoading: false,
        user: firebaseUser,
        errorMessage: null,
        success: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        success: false,
      );
    }
  }
}