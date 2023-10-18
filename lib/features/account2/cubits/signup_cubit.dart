import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/usecases/constants.dart';
import '../../../../core/error/failures.dart';
import '../../../core/models/user_model.dart';
import '../../../../core/usecases/enums.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

part 'signup_state.dart';

@injectable
class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  Future<void> create({required BuildContext context, required UserModel model}) async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));
      Either<Failure, UserCredential> result = await authLogic.createAccount(
        context: context, model: model,
      );
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
