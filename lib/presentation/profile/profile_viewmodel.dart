import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/presentation/profile/profile_state.dart';
import 'package:poster/providers.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    // 初期状態を返す（isLoading: trueで読み込み開始を示す）
    return const ProfileState(isLoading: true);
  }

  /// プロフィール情報を読み込む
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final userUseCase = ref.read(userUseCaseProvider);
      final user = await userUseCase.getCurrentUser();
      state = ProfileState(
        user: user,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = ProfileState(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
