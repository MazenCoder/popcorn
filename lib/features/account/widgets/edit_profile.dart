import 'package:popcorn/packages/bottom_sheet/bottom_sheets/material_bottom_sheet.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../packages/country_code/country_code_picker.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import '../../../core/controllers/user/user_logic.dart';
import '../../../core/theme/generateMaterialColor.dart';
import '../../../../../core/usecases/constants.dart';
import '../../../core/usecases/clip_path_class.dart';
import '../../../core/widgets_helper/widgets.dart';
import '../../../../../core/usecases/enums.dart';
import 'package:image_picker/image_picker.dart';
import '../../chat/widgets/user_badges.dart';
import '../widgets/user_modal_fit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
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
  final DateFormat dateFormat = DateFormat("yyyy MM dd");
  final _form = GlobalKey<FormState>();
  String _countryName = 'المغرب';
  final picker = ImagePicker();
  String _dialingCode = '+212';
  String _countryCode = 'MA';
  late DateTime initialDate;
  String initialValue = '';
  DateTime? dateBirth;


  @override
  void initState() {
    final user = userState.user!;
    _displayName.text = user.displayName;
    _phoneController.text = user.phone??'';
    _bioController.text = user.bio??'';
    _countryName = user.countryName ?? _countryName;
    _countryCode = user.countryCode ?? _countryCode;
    _dialingCode = user.dialingCode ?? _dialingCode;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: primaryColor,
                                  borderRadius: const BorderRadius.only(
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
                                      style: context.textTheme.bodyText2?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text('account_created'.trArgs([utilsLogic.accountCreateAt(user)]),
                                            textAlign: TextAlign.center,
                                            style: context.textTheme.bodyText2?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        UserBadges(user: user, size: 15),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Positioned(
                            top: 2,
                            left: 2,
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
                                  },
                                  initialSelection: _countryName,
                                  favorite: [_dialingCode, _countryName],
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
                            Card(
                              child: ListTile(
                                onTap: () async {
                                  final navigator = Navigator.of(context);
                                  bool success = await utilsLogic.updateAge(context, navigator);
                                  if (success) {
                                    setState(() {});
                                  }
                                },
                                leading: const Icon(Icons.calendar_month),
                                title: Text('date_birthday'.tr),
                                subtitle: Text(user.dateBirth != null ?
                                dateFormat.format(user.dateBirth!) : '__/__/__'),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Card(
                              child: ListTile(
                                onTap: () async {
                                  String? email = await authLogic.resetPasswordDialog(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (email != null) {
                                    await authLogic.resetPassword(context, email);
                                  }
                                },
                                trailing: const Icon(MdiIcons.lockReset),
                                title: Text(
                                  'reset_pass'.tr,
                                  // style: GoogleFonts.notoSans(),
                                ),
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
                                icon: const Icon(Icons.save),
                                label: Text('save'.tr,
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  if (_form.currentState?.validate()??false) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                   await userLogic.updateInfo(
                                     displayName: _displayName.text.trim(),
                                     phone: _phoneController.text.trim(),
                                     bio: _bioController.text.trim(),
                                     countryName: _countryName,
                                     dialingCode: _dialingCode,
                                     countryCode: _countryCode,
                                     context: context,
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
