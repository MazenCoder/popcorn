import '../../../../core/widgets_helper/responsive_safe_area.dart';
import '../../../../core/widgets_helper/loading_app.dart';
import '../../../../core/widgets_helper/error_app.dart';
import '../../../account2/screens/login_screen.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/usecases/constants.dart';
import '../../../navigation/navigation_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import '../cubit/splash_cubit.dart';
import 'package:get/get.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => BlocProvider<SplashCubit>(
        create: (_) => getIt<SplashCubit>()..initApp(),
        child: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state.requestState == RequestState.error) {
              Get.offAll(() => ErrorApp(message: state.message));
            } else if (state.requestState == RequestState.loaded) {
              // final hideIntro = userState.user?.hideIntro??false;
              Get.offAll(() => const NavigationApp());
              // Get.offAll(() => hideIntro ?
              // const NavigationApp() :
              // const OnboardingScreen());
            } else if (state.requestState == RequestState.network) {
              Get.offAll(() => ErrorApp(message: state.message));
            } else {
              Get.offAll(() => const LoginScreen());
            }
          },
          child: const LoadingApp()
        ),
      ),
    );
  }
}
