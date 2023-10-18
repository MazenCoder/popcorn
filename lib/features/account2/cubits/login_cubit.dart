import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/usecases/constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/enums.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login({required String email, required String pass}) async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));
      Either<Failure, UserCredential> result = await authLogic.login(email: email, pass: pass);
      return result.fold(
        (l) => emit(state.copyWith(requestState: l.state, message: l.message)),
         (r) => emit(state.copyWith(requestState: RequestState.loaded, message: 'successful'.tr)),
      );
    } catch(e) {
      return emit(state.copyWith(
        requestState: RequestState.error,
        message: '$e',
      ));
    }
  }
}
