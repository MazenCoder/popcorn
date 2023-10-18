import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:popcorn/core/usecases/enums.dart';
import 'package:popcorn/core/mobx/mobx_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:popcorn/generated/assets.dart';
import '../../../core/usecases/constants.dart';
import 'package:flutter/material.dart';
import '../models/room_model.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:io';



class CreateRoom extends StatefulWidget {
  const CreateRoom({Key? key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {

  final TextEditingController _nameController = TextEditingController() ;
  final TextEditingController _descController = TextEditingController() ;
  final _form = GlobalKey<FormState>();
  final picker = ImagePicker();
  final MobxApp _mobxApp = MobxApp();
  // File? _image;


  @override
  void initState() {
    UserModel user = userState.user!;
    _nameController.text = user.displayName;
    _descController.text = "ann_text".tr;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final user = userState.user!;
    return Scaffold(
      appBar: AppBar(
        title: Text('create_room'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Observer(
        builder: (_) {
          return Container(
            decoration: (_mobxApp.fileBackground != null) ?
            BoxDecoration(
              image: DecorationImage(
                image: Image.file(
                  _mobxApp.fileBackground!,
                  width: Get.width,
                  height: Get.height,
                ).image,
                fit: BoxFit.fill,
              ),
            ) : null,
            child: Form(
              key: _form,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                              onTap: () async {
                                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                  if (croppedFile != null && mounted) {
                                    _mobxApp.setFile(croppedFile);
                                  }
                                } else {
                                  _mobxApp.setFile(null);
                                }
                              },
                            child: (_mobxApp.file != null) ?
                            SizedBox(
                              height: 105.0,
                              width: 105.0,
                              child: Material(
                                child: Image.file(
                                  _mobxApp.file!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ) : SizedBox(
                              height: 105.0,
                              width: 105.0,
                              child: Material(
                                child: Image.asset(
                                  Assets.imagesDefaultImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'room_name'.tr,
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


                        const SizedBox(height: 20),

                        TextFormField(
                          minLines: 4, maxLines:6,
                          controller: _descController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'announcement'.tr,
                          ),
                          validator: (val) {
                            final field = val??'';
                            if (field.isEmpty) {
                              return 'required_field'.tr;
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: Get.width,
                          child: ElevatedButton.icon(
                            icon: (_mobxApp.fileBackground == null) ?
                            const Icon(MdiIcons.imageAlbum) :
                            const Icon(MdiIcons.delete),
                            label: Text(
                              (_mobxApp.fileBackground == null) ?
                                'choose_background_image'.tr :
                              'remove_background_image'.tr,
                            ),
                            onPressed: () async {
                              if (_mobxApp.fileBackground == null) {
                                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  File? croppedFile = await utilsLogic.croppedFile(File(pickedFile.path));
                                  if (croppedFile != null && mounted) {
                                    _mobxApp.setFileBackground(croppedFile);
                                  }
                                }
                              } else {
                                _mobxApp.setFileBackground(null);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: Get.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_form.currentState?.validate()??false) {
                                if (_mobxApp.file != null) {
                                  final model = RoomCreateModel(
                                    id: const Uuid().v4(),
                                    author: auth.currentUser!.uid,
                                    name: _nameController.text.trim(),
                                    description: _descController.text.trim(),
                                    toastMessage: 'defaultWelcomeMessage'.tr,
                                    status: RoomStatus.active.id,
                                    members: [],
                                    banned: [],
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  );

                                  bool success = await roomLogic.createRoom(
                                    backgroundFile: _mobxApp.fileBackground!,
                                    imageFile: _mobxApp.file!,
                                    context: context,
                                    model: model,
                                  );

                                  if (success) Get.back();
                                } else {
                                  utilsLogic.showSnack(
                                    type: SnackBarType.info,
                                    message: 'please_select_room_photo'.tr,
                                  );
                                }
                              }
                            },
                            child: Text('create_free'.tr),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
