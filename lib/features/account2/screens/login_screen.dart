import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../splash/presentation/screens/splash_screen.dart';
import '../../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/loading_app.dart';
import '../../../../core/injection/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import '../widgets/initial_login.dart';
import '../cubits/login_cubit.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        backgroundColor: headlineColor,
        body: BlocProvider<LoginCubit>(
          create: (_) => getIt<LoginCubit>(),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.requestState == RequestState.error) {
                utilsLogic.showSnack(
                  type: SnackBarType.error,
                  message: state.message,
                );
              }
            },
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.requestState == RequestState.init) {
                  return InitialLogin(
                    emailController: _emailController,
                    passController: _passController,
                  );
                } else if (state.requestState == RequestState.loading) {
                  return const LoadingApp();
                } else if (state.requestState == RequestState.loaded) {
                  return const SplashScreen();
                } else if (state.requestState == RequestState.error) {
                  return InitialLogin(
                    emailController: _emailController,
                    passController: _passController,
                  );
                }
                return InitialLogin(
                  emailController: _emailController,
                  passController: _passController,
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
