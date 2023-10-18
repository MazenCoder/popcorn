import '../../../packages/country_code/country_code_picker.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/widgets_helper/splash_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/usecases/enums.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import '../../navigation/navigation_app.dart';
import '../../../core/models/user_model.dart';
import 'package:popcorn/core/util/img.dart';
import '../../widgets/web_view_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:developer';




class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formSignUp = GlobalKey<FormState>();
  late AnimationController _animController;
  String _countryName = 'العربية السعودية';
  late Animation<double> _animation;
  String _dialingCode = '+966';
  String _countryCode = 'SA';
  bool checkedValue = false;


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
    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
            color: utilsState.isDarkTheme.value ?
            null : primaryColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Form(
          key: _formSignUp,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: _animation,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        IMG.logo2, height: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _displayNameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'display_name'.tr,
                        ),
                        validator: (val) {
                          final field = val??'';
                          if(field.isEmpty) {
                            return 'required_field'.tr;
                          } return null;
                        },
                      ),

                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (CountryCode countryCode) {
                              _dialingCode = countryCode.toString();
                              _countryName = countryCode.name!;
                              _countryCode = countryCode.code!;
                              log(_dialingCode);
                              log(_countryName);
                              log(_countryCode);
                            },
                            initialSelection: _countryCode,
                            favorite: [_dialingCode, _countryCode],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                          ),

                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'phone_number'.tr,
                              ),
                              validator: (val) {
                                final field = val??'';
                                if(field.isEmpty) {
                                  return 'required_field'.tr;
                                } else if(!GetUtils.isPhoneNumber(field.trim())) {
                                  return 'phone_not_valid'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CheckboxListTile(
                          title: Text('iam_over_16'.tr),
                          checkColor: Colors.white,
                          activeColor: primaryColor,
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        RichText(
                          text: TextSpan(
                            text: 'terms_content'.tr,
                            style: Get.textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: 'terms_service'.tr,
                                style: Get.textTheme.bodyText2?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  Get.to(() => WebVewApp(
                                    title: 'terms_service'.tr,
                                    url: 'https://flutter.dev',
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),

                  SizedBox(
                    width: Get.width - 100,
                    child: ElevatedButton(
                      child: Text('sign_up'.tr),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formSignUp.currentState?.validate()??false) {
                          if (checkedValue) {
                            // final model = UserModel(
                            //   role: 'user', uid: '',
                            //   uniqueKey: utilsLogic.createUniqueId(),
                            //   email: _emailController.text.trim(),
                            //   displayName: _displayNameController.text.trim(),
                            //   password: _passController.text.trim(),
                            //   phone: _phoneController.text.trim(),
                            //   countryCode: _countryCode,
                            //   countryName: _countryName,
                            //   dialingCode: _dialingCode,
                            //   isVerified: false,
                            //   level: 0,
                            //   status: statusUser.keys.first,
                            //   timestamp: FieldValue.serverTimestamp(),
                            //   token: notificationState.token,
                            // );
                            // await authLogic.createAccount(
                            //   model: model, context: context,
                            // ).then((value) {
                            //   if (value != null) {
                            //     Get.offAll(() => SplashApp(
                            //       home: const NavigationApp(),
                            //     ));
                            //   }
                            // });
                          } else {
                            utilsLogic.showSnack(
                              type: SnackBarType.info,
                              title: 'oops'.tr,
                              message: 'confirm_age'.tr,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: isKeyboardShowing ? 10 : 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
