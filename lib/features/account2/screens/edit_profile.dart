import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../core/controllers/user/user_logic.dart';
import '../../../packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import '../../../core/controllers/notification/notification_controller.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../../packages/country_code/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../../../core/usecases/constants.dart';
import '../../../core/usecases/clip_path_class.dart';
import '../../../../../core/usecases/enums.dart';
import 'package:image_picker/image_picker.dart';
import '../../chat/widgets/user_badges.dart';
import '../../widgets/widgets.dart';
import '../widgets/user_modal_fit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:io';




class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final DateFormat dateFormat = DateFormat("yyyy/MM/dd");
  // List<bool> _selections = [true, false, false];
  final _form = GlobalKey<FormState>();
  String _countryName = 'المغرب';
  final picker = ImagePicker();
  String _dialingCode = '+212';
  String _countryCode = 'MA';
  late DateTime initialDate;
  String initialValue = '';
  DateTime? dateBirth;
  // int? genderId;
  Genders? gender;

  @override
  void initState() {
    final user = userState.user!;
    _displayName.text = user.displayName;
    _phoneController.text = user.phone??'';
    _bioController.text = user.bio??'';
    _countryName = user.countryName ?? _countryName;
    _countryCode = user.countryCode ?? _countryCode;
    _dialingCode = user.dialingCode ?? _dialingCode;
    int? genderId = userState.user?.genderId;
    if (genderId != null) {
      gender = Genders.values.firstWhereOrNull((item) => item.id == genderId);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    bool isRtl = languageLogic.isRtl();
    return ResponsiveSafeArea(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: GetBuilder<UserLogic>(
              builder: (logic) {
                final user = logic.state.user!;
                return Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipPath(
                            clipper: ClipPathClass(),
                            child: Container(
                                width: Get.width,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Hero(
                                          tag: user.uid,
                                          child: userCircleAvatar(user, 60),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: SizedBox(
                                            height: 21,
                                            width: 21,
                                            child: Material(
                                                type: MaterialType.transparency,
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white, width: 2),
                                                    color: primaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(1000.0),
                                                    onTap: () async {
                                                      final action = await showMaterialModalBottomSheet(
                                                        builder: (context) => const UserModalFit(),
                                                        backgroundColor: Colors.transparent,
                                                        context: context,
                                                        expand: false,
                                                      );
                                                      await Future.delayed(const Duration(milliseconds: 600));
                                                      if (action != null && action == ActionSelect.camera) {
                                                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                                                        if (pickedFile != null) {
                                                          File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                                          if (croppedFile != null) {
                                                            if (!mounted) return;
                                                            await userLogic.uploadPhotoProfile(croppedFile);
                                                          }
                                                        }
                                                      } else if (action != null && action == ActionSelect.gallery) {
                                                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                                        if (pickedFile != null) {
                                                          File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                                          if (croppedFile != null) {
                                                            if (!mounted) return;
                                                            await userLogic.uploadPhotoProfile(croppedFile);
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 16.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    getUsername(
                                      user: user,
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text('account_created'.trArgs([utilsLogic.accountCreateAt(user)]),
                                            textAlign: TextAlign.center,
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        UserBadges(
                                          user: user,
                                          size: 15,
                                          color: headlineColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Positioned(
                            top: 2,
                            left: isRtl ? null : 2,
                            right: isRtl ? 2 : null,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _displayName,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                hintText: 'full_name'.tr,
                              ),
                              validator: (val) {
                                final field = val ?? '';
                                if (field.isEmpty) {
                                  return 'required_field'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            //! Phone
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
                                  initialSelection: _countryName,
                                  favorite: [_dialingCode, _countryName],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'phone_number'.tr,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: (user.genderId != null) ?
                                  () => utilsLogic.showSnack(
                                type: SnackBarType.info,
                                title: 'account_management'.tr,
                                message: 'please_contact_admin_change_info_account'.tr,
                              ) : null,
                              child: AbsorbPointer(
                                absorbing: user.genderId != null,
                                child: DropdownButtonFormField2(
                                  value: gender,
                                  decoration: InputDecoration(
                                    filled: true,
                                    isDense: true,
                                    fillColor: Colors.transparent,
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
                                    gender = value;
                                    log('$value');
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            //! Bio
                            TextField(
                              controller: _bioController,
                              maxLength: 120,
                              minLines: 3,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                hintText: 'bio'.tr,
                              ),
                            ),

                            const SizedBox(height: 16),

                            //! Date birthday
                            InkWell(
                              onTap: (user.dateBirth != null) ? () => utilsLogic.showSnack(
                                type: SnackBarType.info,
                                title: 'account_management'.tr,
                                message: 'please_contact_admin_change_info_account'.tr,
                              ) : null,
                              child: AbsorbPointer(
                                absorbing: user.dateBirth != null,
                                child: Card(
                                  color: context.theme.colorScheme.background,
                                  child: ListTile(
                                    onTap: () async {
                                      final navigator = Navigator.of(context);
                                      bool success = await utilsLogic.updateAge(context, navigator);
                                      if (success) {
                                        setState(() {});
                                      }
                                    },
                                    leading: Icon(
                                      Icons.calendar_month,
                                      color: primaryColor,
                                    ),
                                    title: Text('date_birthday'.tr),
                                    subtitle: Text(user.dateBirth != null ?
                                    dateFormat.format(user.dateBirth!) : '__/__/__'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),

                            //! Reset Password
                            Card(
                              color: context.theme.colorScheme.background,
                              child: ListTile(
                                onTap: () async {
                                  String? email = await authLogic.resetPasswordDialog(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (email != null && context.mounted) {
                                    await authLogic.resetPassword(context, email);
                                  }
                                },
                                trailing: Icon(
                                  MdiIcons.email,
                                  color: primaryColor,
                                ),
                                title: Text('reset_email'.tr),
                                subtitle: Text(user.email,
                                  style: context.textTheme.bodySmall,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Card(
                              color: context.theme.colorScheme.background,
                              child: ListTile(
                                onTap: () async {
                                  String? email = await authLogic.resetPasswordDialog(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (email != null && context.mounted) {
                                    await authLogic.resetPassword(context, email);
                                  }
                                },
                                trailing: Icon(
                                  MdiIcons.lockReset,
                                  color: primaryColor,
                                ),
                                title: Text('reset_pass'.tr),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: Get.width,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                      side: BorderSide(color: primaryColor)
                                    ),
                                  ),
                                ),
                                icon: Icon(Icons.save,
                                  color: headlineColor,
                                ),
                                label: Text('save'.tr,
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: headlineColor,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_form.currentState?.validate()??false) {
                                    FocusManager.instance.primaryFocus?.unfocus();

                                    if (gender == null) {
                                      return utilsLogic.showSnack(
                                        type: SnackBarType.info,
                                        message: 'pls_select_gender'.tr,
                                      );
                                    }

                                   await userLogic.updateInfo(
                                     context: context,
                                     user: logic.state.user!.copyWith(
                                       displayName: _displayName.text.trim(),
                                       phone: (_phoneController.text.isNotEmpty) ? _phoneController.text.trim() : null,
                                       bio: (_bioController.text.isNotEmpty) ? _bioController.text.trim() : null,
                                       countryName: (_phoneController.text.isNotEmpty) ? _countryName : null,
                                       dialingCode: (_phoneController.text.isNotEmpty) ? _dialingCode : null,
                                       countryCode: (_phoneController.text.isNotEmpty) ? _countryCode : null,
                                       token: NotificationController.firebaseAppToken,
                                       genderId: gender?.id,
                                     ),
                                   );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                );
              },
            )
          ),
        );
      },
    );
  }
}
