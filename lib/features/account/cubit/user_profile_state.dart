part of 'user_profile_cubit.dart';


abstract class UserProfileState extends Equatable {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
  @override
  List<Object> get props => [];
}


class UserProfileLoaded extends UserProfileState {
  final UserModel user;
  const UserProfileLoaded({
    required this.user,
  });

  @override
  List<Object?> get props => [
    user,
  ];
}

class UserProfileError extends UserProfileState {
  final String message;
  const UserProfileError({required this.message});

  @override
  List<Object> get props => [message];
}