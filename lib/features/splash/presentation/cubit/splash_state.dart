part of 'splash_cubit.dart';


class SplashState extends Equatable {
  final RequestState requestState;
  final String message;
  const SplashState({
    this.requestState = RequestState.loading,
    this.message = 'error_wrong',
  });

  SplashState copyWith({
    RequestState? requestState,
    String? message,
  }) {
    return SplashState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    requestState,
    message,
  ];
}

/*
@immutable
abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
  @override
  List<Object?> get props => [];
}


class SplashLoading extends SplashState {
  const SplashLoading();
  @override
  List<Object> get props => [];
}

class SplashLoaded extends SplashState {
  const SplashLoaded();

  @override
  List<Object> get props => [];
}

class SplashError extends SplashState {
  final String message;
  const SplashError({required this.message});

  @override
  List<Object> get props => [message];
}
*/