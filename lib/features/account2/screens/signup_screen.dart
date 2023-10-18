import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../splash/presentation/screens/splash_screen.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/loading_app.dart';
import '../../../core/injection/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import '../widgets/initial_signup.dart';
import 'package:flutter/material.dart';
import '../cubits/signup_cubit.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
        builder: (_) => Scaffold(
          backgroundColor: headlineColor,
          body: BlocProvider<SignupCubit>(
            create: (_) => getIt<SignupCubit>(),
            child: BlocListener<SignupCubit, SignupState>(
              listener: (context, state) {
                if (state.requestState == RequestState.error) {
                  utilsLogic.showSnack(
                    type: SnackBarType.error,
                    message: state.message,
                  );
                }
              },
              child: BlocBuilder<SignupCubit, SignupState>(
                builder: (context, state) {
                  if (state.requestState == RequestState.init) {
                    return InitialSignup(
                      fullNameController: _fullNameController,
                      confirmPassController: _confirmPassController,
                      emailController: _emailController,
                      passController: _passController,
                    );
                  } else if (state.requestState == RequestState.loading) {
                    return const LoadingApp();
                  } else if (state.requestState == RequestState.loaded) {
                    return const SplashScreen();
                  } else if (state.requestState == RequestState.error) {
                    return InitialSignup(
                      fullNameController: _fullNameController,
                      confirmPassController: _confirmPassController,
                      emailController: _emailController,
                      passController: _passController,
                    );
                  }
                  return InitialSignup(
                    fullNameController: _fullNameController,
                    confirmPassController: _confirmPassController,
                    emailController: _emailController,
                    passController: _passController,
                  );
                },
              ),
            ),
          )
        )
    );
  }
}
