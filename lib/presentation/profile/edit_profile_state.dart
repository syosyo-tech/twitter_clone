/// プロフィール編集画面の状態
class EditProfileState {
  const EditProfileState({
    this.username = '',
    this.bio = '',
    this.email = '',
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  final String username;
  final String bio;
  final String email;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  EditProfileState copyWith({
    String? username,
    String? bio,
    String? email,
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return EditProfileState(
      username: username ?? this.username,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      success: success ?? this.success,
    );
  }
}
