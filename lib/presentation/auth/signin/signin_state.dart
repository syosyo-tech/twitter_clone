import 'package:firebase_auth/firebase_auth.dart';

class SigninState {
  const SigninState({
    this.email = '',
    this.password = '',
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
  final bool success;

  SigninState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    String? email,
    String? password,
    bool success = false,
  }) {
    return SigninState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
      success: success ? true : this.success,
    );
  }
}