import 'package:popcorn/core/controllers/notification/notification_controller.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../../core/theme/generateMaterialColor.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/usecases/enums.dart';
import '../../../core/mobx/mobx_app.dart';
import '../../widgets/web_view_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../cubits/signup_cubit.dart';
import 'package:get/get.dart';





class InitialSignup extends StatefulWidget {
  final TextEditingController fullNameController;
  final TextEditingController confirmPassController;
  final TextEditingController emailController;
  final TextEditingController passController;
  const InitialSignup({Key? key,
    required this.fullNameController,
    required this.confirmPassController,
    required this.emailController,
    required this.passController,
  }) : super(key: key);

  @override
  _InitialSignupState createState() => _InitialSignupState();
}

class _InitialSignupState extends State<InitialSignup> {

  GroupController controller = GroupController(initSelectedItem: []);
  final _formSignUp = GlobalKey<FormState>();
  final MobxApp mobxApp = MobxApp();
  // String countryName = 'المغرب';
  // String dialingCode = '+212';
  // String countryCode = 'MA';
  bool agreed = false;
  int? genderId;


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () => Get.back(),
          ),
        ),
        // backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formSignUp,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('register'.tr,
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

                        //! Full Name
                        TextFormField(
                          controller: widget.fullNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'full_name'.tr,
                            filled: true,
                            errorStyle: TextStyle(color: headlineColor),
                          ),
                          validator: (val) {
                            final field = val??'';
                            if(field.isEmpty) {
                              return 'required_field'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        //! Email
                        TextFormField(
                          controller: widget.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'email'.tr,
                            filled: true,
                            errorStyle: TextStyle(color: headlineColor),
                          ),
                          validator: (val) {
                            final field = val??'';
                            if(field.isEmpty) {
                              return 'required_field'.tr;
                            } else if (!GetUtils.isEmail(field.trim())) {
                              return 'enter_valid_email'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        //! Password & Confirm
                        Observer(
                          builder: (_) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
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
                                    if(field.isEmpty) {
                                      return 'required_field'.tr;
                                    } else if (field.length < 8) {
                                      return 'password_too_short'.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: widget.confirmPassController,
                                  obscureText: mobxApp.obscureText,
                                  keyboardType: TextInputType.text,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: 'confirm_password'.tr,
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
                                  // onChanged: (val) => mobxApp.setPassStrength(val.length.toDouble()),
                                  validator: (val) {
                                    final field = val?.trim()??'';
                                    if (field.isEmpty) {
                                      return 'required_field'.tr;
                                    } else if (field.length < 8) {
                                      return 'password_too_short'.tr;
                                    } else if (field != widget.passController.text.trim()) {
                                      return 'not_match'.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                /*
                                Observer(
                                  builder: (_) {
                                    if (mobxApp.passStrength > 0) {
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: LinearProgressIndicator(
                                          value: valueLinear(mobxApp.passStrength),
                                          backgroundColor: Colors.grey[300],
                                          minHeight: 5,
                                          color: colorLinear(mobxApp.passStrength),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                                */
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        /*
                        //! Phone
                        Row(
                          children: [
                            CountryCodePicker(
                              onChanged: (CountryCode country) {
                                dialingCode = country.toString();
                                countryName = country.name!;
                                countryCode = country.code!;
                                log(dialingCode);
                                log(countryName);
                                log(countryCode);
                              },
                              initialSelection: countryCode,
                              favorite: [dialingCode, countryCode],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.cairo(color: primaryColor),
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'phone_number'.tr,
                                  filled: true,
                                  errorStyle: TextStyle(color: headlineColor),
                                ),
                                validator: (val) {
                                  final field = val ?? '';
                                  if (field.isEmpty) {
                                    return 'required_field'.tr;
                                  } else if (!GetUtils.isPhoneNumber(field.trim())) {
                                    return 'phone_not_valid'.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        */

                        /*
                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            isDense: true,
                            filled: true,
                            contentPadding: EdgeInsets.zero,
                            errorStyle: TextStyle(color: headlineColor),
                          ),
                          isExpanded: true,
                          hint: Text('gender'.tr),
                          buttonStyleData: const ButtonStyleData(height: 50),
                          items: Genders.values.map((item) =>
                              DropdownMenuItem(
                                value: item,
                                child: Text(item.value.tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              )).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'pls_select_gender'.tr;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            genderId = value?.id;
                            log('$genderId');
                          },
                        ),
                        */

                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: agreed,
                          onChanged: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              agreed = value ?? false;
                            });
                          },
                        ),
                        Expanded(
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
                      ],
                    ),
                    Container(
                      width: Get.width - 100,
                      height: 40,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(20),
                        // gradient: linearGradient(-50,
                        //   [
                        //     "#455EED 17.08%",
                        //     "#F7603F 80.68%",
                        //     "#ED9B21 95.53%",
                        //     "#FFCA42 111.52%",
                        //   ],
                        // ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text('register'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: headlineColor,
                          ),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formSignUp.currentState?.validate()??false) {
                            if (agreed) {
                              final model = UserModel(
                                displayName: widget.fullNameController.text.trim(),
                                token: NotificationController.firebaseAppToken,
                                password: widget.passController.text.trim(),
                                email: widget.emailController.text.trim(),
                                createdAt: DateTime.now(),
                                lastSeen: DateTime.now(),
                                isVerified: false,
                                hideIntro: false,
                                isBanned: false,
                                role: 'user',
                                blocks: [],
                                uid: '',
                              );
                              context.read<SignupCubit>().create(
                                context: context, model: model,
                              );
                            } else {
                              utilsLogic.showSnack(
                                type: SnackBarType.info,
                                title: 'oops'.tr,
                                message: 'pls_agree_terms_Conditions'.tr,
                              );
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
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