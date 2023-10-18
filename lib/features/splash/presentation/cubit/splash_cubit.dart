import '../../../../core/usecases/constants.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/usecases/enums.dart';
import '../../../../core/error/failures.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> initApp() async {
    try {
      emit(state.copyWith(requestState: RequestState.loading));
      Either<Failure, UserModel> result = await userLogic.initApp();
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
