import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/features/account/widgets/forgot_pass.dart';
import 'package:popcorn/features/account/pages/sign_up_page.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/splash_app.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import '../../navigation/navigation_app.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;



class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formSignIn = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  void _initAnimation() {
    try {
      _animController = AnimationController(
          duration: const Duration(seconds: 5), vsync: this);
      final curvedAnimation = CurvedAnimation(
        parent: _animController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      );

      _animation = Tween<double>(
          begin: 0, end: 2 * math.pi).animate(curvedAnimation)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animController.reverse();
          } else if (status == AnimationStatus.dismissed) {
            _animController.forward();
          }}
        );
      _animController.forward();
    } catch(e) {
      _animController.dispose();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Get.back(),
            ),
          ),
          // backgroundColor: backgroundLite,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FadeTransition(
                          opacity: _animation,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(
                              IMG.logo2,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'email_address'.tr,
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
                                controller: _passController,
                                obscureText: mobxApp.obscureText,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'password'.tr,
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
                                  if(field.isEmpty) {
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
                              padding: const EdgeInsets.only(top: 8, left: 20.0),
                              child: InkWell(
                                child: Text('forgot_pass'.tr,
                                  style: Get.textTheme.bodyText2?.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        width: Get.width,
                        child: ElevatedButton(
                          child: Text('login'.tr),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formSignIn.currentState?.validate()??false) {
                              // await authLogic.signInWithEmailAndPass(
                              //   context: context, email: _emailController.text.trim(),
                              //   pass: _passController.text.trim(),
                              // ).then((value) {
                              //   if (value != null) {
                              //     Get.offAll(() => SplashApp(
                              //       home: const NavigationApp(),
                              //     ));
                              //   }
                              // });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('dont_have_account'.tr),
                          const SizedBox(width: 5.0),
                          InkWell(
                            onTap: () => Get.to(() => const SignUpPage()),
                            child: Text('register'.tr,
                              style: Get.textTheme.bodyText2?.copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
