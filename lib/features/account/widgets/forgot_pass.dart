import 'package:popcorn/core/widgets_helper/responsive_safe_area.dart';
import 'package:popcorn/core/usecases/enums.dart';
import '../../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



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
            elevation: 0.5,
            centerTitle: true,
            title: Text('forgot_password'.tr),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Get.back(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formEmail,
                child: Column(
                  children: [
                    const SizedBox(height: 8,),
                    Text('enter_your_email'.tr,
                      style: Get.textTheme.bodyText2?.copyWith(
                        fontSize: 22
                      ),
                    ),
                    const SizedBox(height: 28),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          // cursorColor: greyColor,
                          decoration: InputDecoration(
                            hintText: 'email_address'.tr,
                          ),
                          validator: (val) {
                            final field = val??'';
                            if(field.isEmpty) {
                              return 'required_field'.tr;
                            } else if (!GetUtils.isEmail(field)) {
                              return 'email_invalid'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: Get.width,
                          child: ElevatedButton(
                            child: Text('send'.tr),
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formEmail.currentState?.validate()??false) {
                                final email = _emailController.text.trim();
                                await authLogic.resetPassword(context, email).then((value) {
                                  utilsLogic.showSnack(type: SnackBarType.success,
                                    title: 'email_address'.tr,
                                    message: 'check_email'.tr
                                  );
                                  _emailController.clear();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
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
