import '../../../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get/get.dart';


part 'user_profile_state.dart';


@injectable
class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileInitial());


  Future<void> getUserProfile(int ukey) async {
    try {
      emit(const UserProfileInitial());
      if (networkState.isConnected) {
        UserModel? user = await userLogic.getUserByKey(ukey);
        if (user != null) {
          bool isFollowing = await userLogic.isFollowingUser(uid: user.uid);
          userLogic.updateStateFollowing(isFollowing);
          emit(UserProfileLoaded(user: user));
        } else {
          emit(UserProfileError(message: 'user_not_found2'.tr));
        }
      } else {
        emit(UserProfileError(message: 'error_connection'.tr));
      }
    } catch(e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

}
