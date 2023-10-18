import 'package:equatable/equatable.dart';
import '../usecases/enums.dart';


abstract class Failure extends Equatable {
  final String message;
  final RequestState state;
  const Failure({
    required this.message,
    required this.state
  });

  @override
  List<Object> get props => [message, state];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    required RequestState state,
  }) : super(message: message, state: state);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    required RequestState state,
  }) : super(message: message, state: state);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    required RequestState state,
  }) : super(message: message, state: state);
}

class NoDataFailure extends Failure {
  const NoDataFailure({
    required String message,
    required RequestState state,
  }) : super(message: message, state: state);
}