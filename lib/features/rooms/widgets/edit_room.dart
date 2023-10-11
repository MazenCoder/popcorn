import 'package:popcorn/core/widgets_helper/widgets.dart';
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



class EditRoom extends StatefulWidget {
  final RoomModel room;
  const EditRoom({Key? key, required this.room}) : super(key: key);

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final MobxApp mobxApp = MobxApp();
  final picker = ImagePicker();
  File? _image;


  @override
  void initState() {
    _nameController.text = widget.room.name;
    _descController.text = widget.room.description;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = userState.user!;
    return Scaffold(
      appBar: AppBar(
        title: Text('edit_room'.tr),
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
                                  child: imageLiveRoom(widget.room),
                                  // child: Image.asset(IMG.defaultImg),
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
                          await roomLogic.editRoom(
                            context: context,
                            id: widget.room.id,
                            name: _nameController.text.trim(),
                            description: _descController.text.trim(),
                            photoRoomUrl: widget.room.photoRoom,
                            photoRoomPath: _image?.path,
                          ).then((value) {
                            if (value) Get.back();
                          });
                        }
                      },
                      child: Text('update'.tr),
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
