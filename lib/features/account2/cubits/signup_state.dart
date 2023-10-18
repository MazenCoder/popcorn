part of 'signup_cubit.dart';


class SignupState extends Equatable {

  final RequestState requestState;
  final String? message;
  const SignupState({
    this.requestState = RequestState.init,
    this.message,
  });

  SignupState copyWith({
    RequestState? requestState,
    String? message,
  }) {
    return SignupState(
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