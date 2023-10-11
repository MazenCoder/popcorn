import 'package:popcorn/features/rooms/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:popcorn/core/mobx/mobx_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/usecases/constants.dart';
import 'package:popcorn/core/util/img.dart';
import 'package:flutter/material.dart';
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
  final MobxApp mobxApp = MobxApp();
  final picker = ImagePicker();
  File? _image;


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
      body: Form(
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
                        // var photosStatus = await Permission.photos.status;
                        // if (photosStatus.isDenied) {
                        //   openAppSettings();
                        //   return;
                        // }
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          _image = File(pickedFile.path);
                          mobxApp.setImagePath(pickedFile.path);
                        } else {
                          mobxApp.setImagePath("");
                        }
                      },
                      child: Observer(
                        builder: (_) {
                          if (mobxApp.filePath.isNotEmpty) {
                            return SizedBox(
                              height: 105.0,
                              width: 105.0,
                              child: Material(
                                child: Image.file(File(mobxApp.filePath),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 105.0,
                              width: 105.0,
                              child: Material(
                                child: Image.asset(IMG.defaultImg),
                              ),
                            );
                          }
                        },
                      )
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


                  const SizedBox(height: 40),

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

                  const SizedBox(height: 30),

                  SizedBox(
                    width: Get.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_form.currentState?.validate()??false) {
                          int status = roomLogic.getIdStatusRoom('actively'.tr);
                          Map<String, dynamic> readStatus = {};
                          final room = RoomModel(
                            uid: user.uid,
                            id: const Uuid().v4(),
                            photoRoom: _image?.path,
                            idRoom: utilsLogic.createUniqueId(),
                            name: _nameController.text.trim(),
                            description: _descController.text.trim(),
                            welcomeMessage: 'defaultWelcomeMessage'.tr,
                            timestamp: FieldValue.serverTimestamp(),
                            // idRoom: utilsLogic.createUniqueId(),
                            memberIds: [user.uid],
                            recentMessage: 'Chat Created',
                            readStatus: readStatus,
                            micNumber: 5,
                            status: status,
                          );

                          await roomLogic.createRoom(context, room).then((value) {
                            if (value) Get.back();
                          });
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
  }
}
