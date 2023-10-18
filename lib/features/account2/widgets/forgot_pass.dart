import '../../../core/theme/generateMaterialColor.dart';
import '../../../core/usecases/constants.dart';
import '../../../core/usecases/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets_helper/responsive_safe_area.dart';




class ForgotPass extends StatelessWidget {
  ForgotPass({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final _formEmail = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: primaryColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          // backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formEmail,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text('forgot_password'.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('enter_your_email'.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'email'.tr,
                        filled: true,
                        // errorStyle: TextStyle(color: headlineColor),
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
                    const SizedBox(height: 30),
                    Container(
                      width: Get.width - 100,
                      height: 40,
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
                        child: Text('send'.tr,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: headlineColor,
                          ),
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formEmail.currentState?.validate()??false) {
                            final email = _emailController.text.trim();
                            await authLogic.resetPassword(context, email).then((value) {
                              if (value) {
                                _emailController.clear();
                                utilsLogic.showSnack(
                                  type: SnackBarType.success,
                                  title: 'reset_your_password'.tr,
                                  message: 'check_email'.tr
                                );
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
