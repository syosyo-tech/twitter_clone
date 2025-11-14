import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster/data/datastore/auth_datastore.dart';
import 'package:poster/data/datastore/post_datastore.dart';
import 'package:poster/data/datastore/user_datastore.dart';
import 'package:poster/data/repository/auth_repository_impl.dart';
import 'package:poster/data/repository/post_repository_impl.dart';
import 'package:poster/data/repository/user_repository_impl.dart';
import 'package:poster/domain/usecase/auth_usecase.dart';
import 'package:poster/domain/usecase/post_usecase.dart';
import 'package:poster/domain/usecase/user_usecase.dart';
import 'package:poster/presentation/auth/signup/signup_state.dart';
import 'package:poster/presentation/auth/signup/signup_viewmodel.dart';
import 'package:poster/presentation/auth/signin/signin_state.dart';
import 'package:poster/presentation/auth/signin/signin_viewmodel.dart';
import 'package:poster/presentation/compose/compose_state.dart';
import 'package:poster/presentation/compose/compose_viewmodel.dart';
import 'package:poster/presentation/timeline/timeline_state.dart';
import 'package:poster/presentation/timeline/timeline_viewmodel.dart';
import 'package:poster/presentation/timeline/components/post_card_state.dart';
import 'package:poster/presentation/timeline/components/post_card_viewmodel.dart';
import 'package:poster/presentation/profile/profile_state.dart';
import 'package:poster/presentation/profile/profile_viewmodel.dart';
import 'package:poster/presentation/profile/edit_profile_state.dart';
import 'package:poster/presentation/profile/edit_profile_viewmodel.dart';
// ============================================
// Data Layer Providers
// ============================================

/// PostDataStoreのProvider
final postDataStoreProvider = Provider<PostDataStore>((ref) {
  return PostDataStore();
});

/// AuthDataStoreのProvider
final authDataStoreProvider = Provider<AuthDataStore>((ref) {
  return AuthDataStore();
});

/// UserDataStoreのProvider
final userDataStoreProvider = Provider<UserDataStore>((ref) {
  return UserDataStore();
});

// ============================================
// UseCase Layer Providers (Data層のRepositoryImplが実装)
// ============================================

/// PostUseCaseのProvider (PostRepositoryImplが実装)
final postUseCaseProvider = Provider<PostUseCase>((ref) {
  return PostRepositoryImpl(
    dataStore: ref.watch(postDataStoreProvider),
    authUseCase: ref.watch(authUseCaseProvider),
    userUseCase: ref.watch(userUseCaseProvider),
  );
});

/// AuthUseCaseのProvider (AuthRepositoryImplが実装)
final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  return AuthRepositoryImpl(
    dataStore: ref.watch(authDataStoreProvider),
  );
});

/// UserUseCaseのProvider (UserRepositoryImplが実装)
final userUseCaseProvider = Provider<UserUseCase>((ref) {
  return UserRepositoryImpl(
    dataStore: ref.watch(userDataStoreProvider),
    authUseCase: ref.watch(authUseCaseProvider),
  );
});

// ============================================
// Presentation Layer Providers
// ============================================

/// TimelineViewModelのProvider
final timelineViewModelProvider =
    NotifierProvider<TimelineViewModel, TimelineState>(TimelineViewModel.new);

/// PostCardViewModelのProvider
final postCardViewModelProvider =
    NotifierProvider<PostCardViewModel, PostCardState>(PostCardViewModel.new);    

/// ComposeViewModelのProvider
final composeViewModelProvider =
    NotifierProvider<ComposeViewModel, ComposeState>(ComposeViewModel.new);

/// SignupViewModelのProvider
final signupViewModelProvider =
    NotifierProvider<SignupViewModel, SignupState>(SignupViewModel.new);

/// SigninViewModelのProvider
final signinViewModelProvider =
    NotifierProvider<SigninViewModel, SigninState>(SigninViewModel.new);

/// ProfileViewModelのProvider
final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

/// EditProfileViewModelのProvider
final editProfileViewModelProvider =
    NotifierProvider<EditProfileViewModel, EditProfileState>(EditProfileViewModel.new);
