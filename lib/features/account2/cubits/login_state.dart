part of 'login_cubit.dart';


class LoginState extends Equatable {

  final RequestState requestState;
  final String? message;
  const LoginState({
    this.requestState = RequestState.init,
    this.message,
  });

  LoginState copyWith({
    RequestState? requestState,
    String? message,
  }) {
    return LoginState(
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