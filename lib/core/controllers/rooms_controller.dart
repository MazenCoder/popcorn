import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../features/rooms/widgets/create_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/rooms/models/room_model.dart';
import 'package:popcorn/core/usecases/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets_helper/loading_dialog.dart';
import '../theme/generateMaterialColor.dart';
// import 'package:agora_rtm/agora_rtm.dart';
import 'package:mime_type/mime_type.dart';
import '../widgets_helper/widgets.dart';
import 'package:flutter/material.dart';
import '../usecases/constants.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'dart:io';





class RoomsController extends GetxController {
  static RoomsController instance = Get.find();





}