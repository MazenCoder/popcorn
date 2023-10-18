import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/generated/assets.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../splash/presentation/screens/splash_screen.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/mobx/mobx_app.dart';
import '../../widgets/web_view_app.dart';
import 'package:flutter/material.dart';
import '../screens/signup_screen.dart';
import 'package:flutter/gestures.dart';
import '../cubits/login_cubit.dart';
import 'package:get/get.dart';
import 'forgot_pass.dart';



class InitialLogin extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passController;
  const InitialLogin({Key? key,
    required this.emailController,
    required this.passController,
  }) : super(key: key);

  @override
  _InitialLoginState createState() => _InitialLoginState();
}

class _InitialLoginState extends State<InitialLogin> {

  final _formSignIn = GlobalKey<FormState>();
  final MobxApp mobxApp = MobxApp();
  RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");




  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formSignIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Image.asset(
                      Assets.imagesLogo2,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 20),
                    Text('login'.tr,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: widget.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'email_address'.tr,
                            filled: true,
                            errorStyle: TextStyle(color: headlineColor),
                          ),
                          validator: (val) {
                            final field = val??'';
                            if(field.isEmpty) {
                              return 'required_field'.tr;
                            } else if (!GetUtils.isEmail(field.trim())) {
                              return 'email_invalid'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) {
                            return TextFormField(
                              controller: widget.passController,
                              obscureText: mobxApp.obscureText,
                              keyboardType: TextInputType.text,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'password'.tr,
                                filled: true,
                                errorStyle: TextStyle(color: headlineColor),
                                suffixIcon: IconButton(
                                  icon: Icon(mobxApp.obscureText
                                      ? Icons.visibility : Icons.visibility_off,
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    mobxApp.toggle(mobxApp.obscureText = !mobxApp.obscureText);
                                  },
                                ),
                              ),
                              validator: (val) {
                                final field = val??'';
                                if (field.isEmpty) {
                                  return 'required_field'.tr;
                                } else {
                                  return null;
                                }
                              },
                            );
                          },
                        ),
                        InkWell(
                          onTap: () => Get.to(() => ForgotPass()),
                          child: Container(
                            alignment: const Alignment(1.0, 0.0),
                            padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                            child: InkWell(
                              child: Text(
                                  'forgot_pass'.tr,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.underline,
                                    // color: headlineColor,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: Get.width - 100,
                      // height: 40,
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: primaryColor),
                      //   borderRadius: BorderRadius.circular(20),
                      //   gradient: linearGradient(-50,
                      //     [
                      //       "#455EED 17.08%",
                      //       "#F7603F 80.68%",
                      //       "#ED9B21 95.53%",
                      //       "#FFCA42 111.52%",
                      //     ],
                      //   ),
                      // ),
                      child: ElevatedButton(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.transparent,
                        //   foregroundColor: Colors.transparent,
                        //   shadowColor: Colors.transparent,
                        // ),
                        child: Text('login'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: headlineColor,
                          ),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formSignIn.currentState?.validate()??false) {
                            context.read<LoginCubit>().login(
                              email: widget.emailController.text.trim(),
                              pass: widget.passController.text.trim(),
                            );
                          }
                        },
                      ),
                    ),
                    // const SizedBox(height: 20.0),

                    /*
                    const SizedBox(height: 40.0),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'dont_have_account_yet'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: headlineColor
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: ' '),
                            TextSpan(
                                text: 'register'.tr,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: secondaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => const SignupScreen())
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                     */

                    //! SignUp
                    SizedBox(
                      width: Get.width - 100,
                      child: ElevatedButton.icon(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.white,
                        // ),
                        icon: Icon(MdiIcons.account, color: headlineColor),
                        label: Text('register'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: headlineColor
                          ),
                        ),
                        onPressed: () => Get.to(() => const SignupScreen()),
                      ),
                    ),

                    //! OR
                    SizedBox(
                      width: Get.width - 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Expanded(child: Divider(color: Colors.white)),
                          Expanded(child: Divider(color: primaryColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('or'.tr.toUpperCase(),
                              style: context.textTheme.bodyMedium?.copyWith(
                                  // color: headlineColor
                              ),
                            ),
                          ),
                          // const Expanded(child: Divider(color: Colors.white)),
                          Expanded(child: Divider(color: primaryColor)),
                        ],
                      ),
                    ),

                    //! Google
                    SizedBox(
                      width: Get.width - 100,
                      child: ElevatedButton.icon(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.white,
                        // ),
                        icon: Icon(MdiIcons.google, color: headlineColor),
                        label: Text('continue_google'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: headlineColor,
                          ),
                        ),
                        onPressed: () async {
                          final user = await authLogic.signInWithGoogle(context);
                          if (user != null) {
                            Get.to(() => const SplashScreen());
                          }
                        },
                      ),
                    ),

                    //! Apple
                    if (GetPlatform.isIOS)
                      SizedBox(
                        width: Get.width - 100,
                        child: ElevatedButton.icon(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Colors.white,
                          // ),
                          icon: Icon(MdiIcons.apple, color: headlineColor),
                          label: Text('continue_apple'.tr,
                            style: context.textTheme.bodyMedium?.copyWith(
                                color: headlineColor
                            ),
                          ),
                          onPressed: () async {
                            final user = await authLogic.signInWithApple(context);
                            if (user != null) {
                              Get.to(() => const SplashScreen());
                            }
                          },
                        ),
                      ),

                    //! Facebook
                    SizedBox(
                      width: Get.width - 100,
                      child: ElevatedButton.icon(
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.white,
                        // ),
                        icon: Icon(MdiIcons.facebook, color: headlineColor),
                        label: Text('continue_facebook'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                              color: headlineColor
                          ),
                        ),
                        onPressed: () async {
                          final user = await authLogic.signInWithFacebook(context);
                          if (user != null) {
                            Get.to(() => const SplashScreen());
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'agree_terms_service'.tr,
                          style: context.textTheme.bodyMedium,
                          children: <TextSpan>[
                            const TextSpan(text: ' '),
                            TextSpan(
                                text: 'terms_of_use'.tr,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: primaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.to(() => WebVewApp(
                                    title: 'terms_of_service'.tr,
                                    url: termsOfServiceUrl,
                                  ))
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: 'by_sawwl'.tr,
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
