import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/presentation/profile/edit_profile_state.dart';
import 'package:poster/providers.dart';

class EditProfileViewModel extends Notifier<EditProfileState> {
  @override
  EditProfileState build() {
    // 初期状態を返す（successフラグをリセット）
    return const EditProfileState(
      isLoading: true,
      success: false,
    );
  }

  /// 現在のプロフィール情報を読み込む
  Future<void> loadCurrentProfile() async {
    state = state.copyWith(isLoading: true, success: false);

    try {
      final userUseCase = ref.read(userUseCaseProvider);
      final user = await userUseCase.getCurrentUser();
      if (user != null) {
        state = EditProfileState(
          username: user.username,
          bio: user.bio ?? '',
          email: user.email,
          isLoading: false,
          success: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  /// プロフィールを更新
  Future<void> updateProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final userUseCase = ref.read(userUseCaseProvider);
      final authUseCase = ref.read(authUseCaseProvider);

      final currentUser = await userUseCase.getCurrentUser();
      if (currentUser == null) {
        throw Exception('ユーザーが見つかりません');
      }

      // ユーザーネームが変更されている場合、重複チェック
      if (state.username != currentUser.username) {
        final exists = await userUseCase.isUsernameExists(state.username);
        if (exists) {
          throw Exception('このユーザーネームは既に使用されています');
        }
      }

      // Firestoreのユーザー情報を更新
      await userUseCase.updateUser(
        currentUser.uid,
        {
          'username': state.username,
          'bio': state.bio,
          'email': state.email,
        },
      );

      // メールアドレスが変更されている場合、Firebase Authも更新
      final firebaseUser = authUseCase.getCurrentUser();
      if (firebaseUser != null && state.email != firebaseUser.email) {
        await firebaseUser.verifyBeforeUpdateEmail(state.email);
      }

      state = state.copyWith(
        isLoading: false,
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
