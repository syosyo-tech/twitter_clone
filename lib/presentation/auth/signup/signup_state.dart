import 'package:firebase_auth/firebase_auth.dart';

/// サインアップ画面の状態
class SignupState {
  const SignupState({
    this.email = '',
    this.password = '',
    this.username = '',
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.success = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final User? user;
  final String email;
  final String password;
  final String username;
  final bool success;

  SignupState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    String? email,
    String? password,
    String? username,
    bool success = false,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      success: success ? true : this.success,
    );
  }
}