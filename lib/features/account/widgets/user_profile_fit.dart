import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/injection/injection.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../rooms/widgets/full_screen_image.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cubit/user_profile_cubit.dart';
import 'card_profile_shimmer.dart';
import 'display_card_profile.dart';
import 'error_card_profile.dart';



class UserProfileFit extends StatelessWidget {
  final int ukey;
  const UserProfileFit({
    Key? key, required this.ukey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: BlocProvider(
        create: (_) => getIt<UserProfileCubit>()..getUserProfile(ukey),
        child: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileInitial) {
              return const CardProfileShimmer();
            } else if (state is UserProfileLoaded) {
              return DisplayCardProfile(
                user: state.user,
              );
            } else if (state is UserProfileError) {
              return ErrorCardProfile(message: state.message);
            } else {
              return const ErrorCardProfile();
            }
          },
        ),
      ),
    );
  }
}
