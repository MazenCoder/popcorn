import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:popcorn/core/widgets_helper/loading_dialog.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popcorn/core/error/failures.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../usecases/constants.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'app_utils.dart';
import 'dart:async';
import 'dart:io';




@LazySingleton(as: AppUtils)
class AppUtilsImpl implements AppUtils {


  Future<void> changeDialog(BuildContext context) async {
    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('choose_locale'.tr),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Divider(),
          Flexible(
            child: TextButton(
                child: const Text('English'),
                onPressed: () async {
                  // log(context.locale.toString(), name: toString());
                  // context.locale = Locale('fr', 'FR');
                  // await appUtils.setLocale(true);
                  Navigator.pop(context);
                }
            ),
          ),

          Flexible(
            child: TextButton(
                child: const Text(' العربية'),
                onPressed: () async {
                  // log(context.locale.toString(), name: toString());
                  // context.locale = Locale('ar', 'AR');
                  // await appUtils.setLocale(false);
                  Navigator.pop(context);
                }
            ),
          )
        ],
      ),
    ));
  }

  @override
  String accountCreateAt(UserModel account) {
    try {
      return timeago.format(account.timestamp.toDate());
    } catch(e) {
      logger.e('$e');
      return 'a_second_ago'.tr;
    }
  }

  /*
  @override
  Future<void> createRoom(BuildContext context, RoomModel model) async {
    try {
      if (networkState.isConnected) {

        await roomRef.doc(model.idChannel).set(model.toJson());
        AgoraRtmChannel channel = await client.createChannel(model.idChannel);
        channel.onMemberJoined = (AgoraRtmMember member) {
          print("Member joined: " + member.userId + ', channel: ' + member.channelId);
        };
        channel.onMemberLeft = (AgoraRtmMember member) {
          print("Member left: " + member.userId + ', channel: ' + member.channelId);
        };
        channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
          print("Channel msg: " + member.userId + ", msg: " + message.text);
        };
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
    }
  }
   */

  @override
  Future<String?> uploadImageRoom(BuildContext context, File image) async {
    try {
      if (networkState.isConnected) {
        return await _uploadImage(image);
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
    }
  }

  Future getRooms() async {
    // await usersRef.doc(auth.currentUser!.uid)
    //     .collection(KEYS.ROOM).doc(model.id).set(model.toJson());
  }

  // static Future<XFile?> compressImage(String photoId, File image) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   XFile? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
  //     image.absolute.path,
  //     '$path/img_$photoId.jpg',
  //     quality: 70,
  //   );
  //   return compressedImageFile;
  // }


  static Future<String?> _uploadImage(File file) async {
    try {
      String name = basename(file.path);
      final typeImage = name.substring(name.indexOf('.')+1, name.length);
      List<firebase_storage.UploadTask> uploadTasks = [];
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("rooms/${const Uuid().v4()}");
      firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
        contentType: 'image/$typeImage', customMetadata: {'picked-file-path': file.path},
      );

      return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
        return await snapshot.ref.getDownloadURL();
      });
    } catch(e) {
      logger.e('e: $e');
    }
  }

  @override
  Future<UserCredential?> signInWithEmailAndPass({
    required BuildContext context, required String email, required String pass}) async {
    try {
      LoadingDialog.show(context: context);
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: pass);
      if (userCredential.user != null) {
        await updateToken(userCredential);
      }
      if (context.mounted) LoadingDialog.hide(context: context);
      return userCredential;
    } on FirebaseAuthException catch(e) {
      if (context.mounted) LoadingDialog.hide(context: context);
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
        Get.snackbar(
          'user_not_found'.tr,
          'email_not_found'.tr,
          icon: Icon(Icons.warning, color: Colors.red[300]),
          shouldIconPulse: true, barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'wrong_password'.tr,
          'pass_not_correct'.tr,
          icon: Icon(Icons.warning, color: Colors.red[300]),
          shouldIconPulse: true, barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
        logger.e('Wrong password provided for that user.');
      } else {
        logger.e('$e');
        Get.snackbar(
          'oops'.tr,
          'something_wrong'.tr,
          icon: Icon(Icons.warning, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  @override
  Future<void> updateToken(UserCredential currentUser) async {
    String? token = notificationState.token;
    final userDoc = await usersRef.doc(currentUser.user!.uid).get();
    if (userDoc.exists) {
      UserModel user = userModelFromJson(userDoc.data());
      if (token != user.token) {
        await usersRef.doc(currentUser.user!.uid).update({'token': token});
      }
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (networkState.isConnected) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final uerCredential = await auth.signInWithCredential(credential);
        // if (uerCredential != null) {
        //   final model = UserModel(
        //     uid: uerCredential.user!.uid,
        //     firstName: uerCredential.user?.displayName??'',
        //     phone: uerCredential.user?.phoneNumber??'',
        //     lastName: '', timestamp: FieldValue.serverTimestamp(), email: '',
        //   );
        //   await _singUpUser(uerCredential, model);
        //   return uerCredential;
        // }
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
      Get.snackbar(
        'oops'.tr,
        'error_wrong'.tr,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    try {
      if (networkState.isConnected) {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],
        );

        if (result.status == LoginStatus.success) {
          final userData = await FacebookAuth.instance.getUserData(
            fields: "name,email,picture.width(200),birthday,friends,gender,link",
          );

          // Create a credential from the access token
          final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

          // Once signed in, return the UserCredential
          return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        }
      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
      Get.snackbar(
        'oops'.tr,
        'error_wrong'.tr,
        icon: Icon(Icons.warning, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<UserCredential?> signInWithApple() async {
    try {
      if (networkState.isConnected) {
        // final credential = await SignInWithApple.getAppleIDCredential(
        //   scopes: [
        //     AppleIDAuthorizationScopes.email,
        //     AppleIDAuthorizationScopes.fullName,
        //   ],
        //   webAuthenticationOptions: WebAuthenticationOptions(
        //     // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        //     clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
        //     redirectUri: Uri.parse('https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        //     ),
        //   ),
        //   // TODO: Remove these if you have no need for them
        //   nonce: 'example-nonce',
        //   state: 'example-state',
        // );
        //
        // final signInWithAppleEndpoint = Uri(
        //   scheme: 'https',
        //   host: 'flutter-sign-in-with-apple-example.glitch.me',
        //   path: '/sign_in_with_apple',
        //   queryParameters: <String, String>{
        //     'code': credential.authorizationCode,
        //     if (credential.givenName != null)
        //       'firstName': credential.givenName,
        //     if (credential.familyName != null)
        //       'lastName': credential.familyName,
        //       'useBundleId':
        //     Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        //     if (credential.state != null) 'state': credential.state,
        //   },
        // );
        //
        // final session = await client.post(signInWithAppleEndpoint);
        // logger.i(session.body);
        // return await FirebaseAuth.instance.signInWithCredential(credential);

      } else {
        Get.snackbar(
          'oops'.tr,
          'error_connection'.tr,
          backgroundColor: Colors.white,
          icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } catch(e) {
      logger.e('$e');
      Get.snackbar(
        'oops'.tr,
        'error_wrong'.tr,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<void> resetPassword(BuildContext context, String email) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        await auth.sendPasswordResetEmail(email: email);
        if (context.mounted) {
          Get.snackbar(
          'email_address'.tr,
          'check_email'.tr,
          icon: Icon(Icons.check_circle, color: Colors.green[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) LoadingDialog.hide(context: context);
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
          Get.snackbar(
            'oops'.tr,
            'user_not_found'.tr,
            icon: Icon(Icons.warning, color: Colors.red[300]),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 4),
          );
        } else {
          logger.e('$e');
          Get.snackbar(
            'oops'.tr,
            'something_wrong'.tr,
            icon: Icon(Icons.warning, color: Colors.red[300]),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 4),
          );
        }
      } catch(e) {
        logger.e('error --> $e');
        if (context.mounted) LoadingDialog.hide(context: context);
        Get.snackbar(
          'oops'.tr,
          'something_wrong'.tr,
          icon: Icon(Icons.warning, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } else {
      Get.snackbar(
        'oops'.tr,
        'error_connection'.tr,
        icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }



  @override
  Future<void> updatePass(BuildContext context, UserModel model) async {
    if (networkState.isConnected) {
      if (model.password?.isNotEmpty??false) {
        final TextEditingController newPass = TextEditingController();
        final formKey = GlobalKey<FormState>();
        await showDialog(context: context, builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.blue.shade600,
              child: Text('update_pass'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            content: Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                controller: newPass,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'new_pass'.tr,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (val) {
                  final value = val??'';
                  if(value.isEmpty) {
                    return 'required_field'.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('update'.tr,
                ),
                onPressed: () async {
                  if (formKey.currentState?.validate()??false) {
                    try {
                      LoadingDialog.show(context: context);
                      AuthCredential credential = EmailAuthProvider.credential(email: model.email, password: model.password!);

                        await auth.currentUser?.reauthenticateWithCredential(credential);
                        await auth.currentUser?.updatePassword(newPass.text.trim()).then((value) async {
                          await usersRef.doc(model.uid).update({"pass": newPass.text.trim()});
                          if (context.mounted) LoadingDialog.hide(context: context);
                          if (context.mounted) Navigator.pop(context);
                          Get.snackbar(
                            'completed_successfully'.tr,
                            'update_success'.tr,
                            icon: Icon(Icons.check_circle, color: Colors.green[300]),
                            shouldIconPulse: true,
                            barBlur: 20,
                            isDismissible: true,
                            duration: const Duration(seconds: 4),
                          );
                        });

                    }  on FirebaseAuthException catch (e) {
                      if (context.mounted) LoadingDialog.hide(context: context);
                      if (e.code == 'user-not-found') {
                        logger.e('No user found for that email.');
                        Get.snackbar(
                          'oops'.tr,
                          'user_not_found'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'requires-recent-login') {
                        logger.e('requires-recent-login');
                        Get.snackbar(
                          'oops'.tr,
                          'recent_login'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'weak-password') {
                        logger.e('The password provided is too weak.');
                        Get.snackbar(
                          'oops'.tr,
                          'weak_password'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else {
                        logger.e('$e');
                        Get.snackbar(
                          'oops'.tr,
                          'something_wrong'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    } catch(e) {
                      logger.e('$e');
                      if (context.mounted) LoadingDialog.hide(context: context);
                      Get.snackbar(
                        'oops'.tr,
                        'something_wrong'.tr,
                        icon: Icon(Icons.warning, color: Colors.red[300]),
                        shouldIconPulse: true,
                        barBlur: 20,
                        isDismissible: true,
                        duration: const Duration(seconds: 4),
                      );
                    }
                  }
                },
              ),
            ],
          );
        });
      } else {
        final TextEditingController newPass = TextEditingController();
        final TextEditingController oldPass = TextEditingController();
        final formKey = GlobalKey<FormState>();
        await showDialog(context: context, builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.blue.shade600,
              child: Text('update_pass'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Get.textTheme.bodyText2?.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // shrinkWrap: true,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: oldPass,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'old_pass'.tr,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                        final value = val??'';
                        if(value.isEmpty) {
                          return 'required_field'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    TextFormField(
                      autofocus: true,
                      controller: newPass,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'new_pass'.tr,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (val) {
                        final value = val??'';
                        if(value.isEmpty) {
                          return 'required_field'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('cancel'.tr,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('update'.tr,
                ),
                onPressed: () async {
                  if (formKey.currentState?.validate()??false) {
                    try {
                      LoadingDialog.show(context: context);
                      AuthCredential credential = EmailAuthProvider.credential(email: model.email, password: oldPass.text.trim());
                      if (credential != null) {
                        await auth.currentUser?.reauthenticateWithCredential(credential);
                        await auth.currentUser?.updatePassword(newPass.text.trim()).then((value) async {
                          await usersRef.doc(model.uid).update({"pass": newPass.text.trim()});
                          if (context.mounted) LoadingDialog.hide(context: context);
                          if (context.mounted) Navigator.pop(context);
                          Get.snackbar(
                            'completed_successfully'.tr,
                            'update_success'.tr,
                            icon: Icon(Icons.check_circle, color: Colors.green[300]),
                            shouldIconPulse: true,
                            barBlur: 20,
                            isDismissible: true,
                            duration: const Duration(seconds: 4),
                          );
                        });
                      } else {
                        LoadingDialog.hide(context: context);
                        Navigator.pop(context);
                        Get.snackbar(
                          'oops'.tr,
                          'old_pass_not_correct'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    }  on FirebaseAuthException catch (e) {
                      LoadingDialog.hide(context: context);
                      if (e.code == 'user-not-found') {
                        logger.e('No user found for that email.');
                        Get.snackbar(
                          'oops'.tr,
                          'user_not_found'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'requires-recent-login') {
                        logger.e('requires-recent-login');
                        Get.snackbar(
                          'oops'.tr,
                          'recent_login'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else if (e.code == 'weak-password') {
                        logger.e('The password provided is too weak.');
                        Get.snackbar(
                          'oops'.tr,
                          'weak_password'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      } else {
                        logger.e('$e');
                        Get.snackbar(
                          'oops'.tr,
                          'something_wrong'.tr,
                          icon: Icon(Icons.warning, color: Colors.red[300]),
                          shouldIconPulse: true,
                          barBlur: 20,
                          isDismissible: true,
                          duration: const Duration(seconds: 4),
                        );
                      }
                    } catch(e) {
                      logger.e('$e');
                      if (context.mounted) LoadingDialog.hide(context: context);
                      Get.snackbar(
                        'oops'.tr,
                        'something_wrong'.tr,
                        icon: Icon(Icons.warning, color: Colors.red[300]),
                        shouldIconPulse: true,
                        barBlur: 20,
                        isDismissible: true,
                        duration: const Duration(seconds: 4),
                      );
                    }
                  }
                },
              ),
            ],
          );
        });
      }
    } else {
      Get.snackbar(
        'oops'.tr,
        'error_connection'.tr,
        icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<UserCredential?> createAccount({required BuildContext context, required UserModel model}) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: model.email, password: model.password!,
        );
        if (userCredential.user != null) {
          await _singUpUser(userCredential, model);
        }
        if (context.mounted) LoadingDialog.hide(context: context);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (context.mounted) LoadingDialog.hide(context: context);
        if (e.code == 'weak-password') {
          Get.snackbar(
            'oops'.tr,
            'weak_password'.tr,
            icon: Icon(Icons.warning, color: Colors.red[300]),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 4),
          );
          logger.e('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          logger.e('The account already exists for that email');
          Get.snackbar(
            'oops'.tr,
            'email_already_use'.tr,
            icon: Icon(Icons.warning, color: Colors.red[300]),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 4),
          );
        } else {
          logger.e('$e');
          Get.snackbar(
            'oops'.tr,
            'something_wrong'.tr,
            icon: Icon(Icons.warning, color: Colors.red[300]),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: const Duration(seconds: 4),
          );
        }
      } catch (e) {
        if (context.mounted) LoadingDialog.hide(context: context);
        Get.snackbar(
          'oops'.tr,
          'something_wrong'.tr,
          icon: Icon(Icons.warning, color: Colors.red[300]),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: const Duration(seconds: 4),
        );
      }
    } else {
      Get.snackbar(
        'oops'.tr,
        'error_connection'.tr,
        icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _singUpUser(UserCredential? credential, UserModel model) async {
    try {
      if (credential != null) {
        String? token = notificationState.token;
        final document = await usersRef.doc(credential.user!.uid).get();
        if (document.exists) {
          // await usersRef.doc(credential.user!.uid).update(model.toJsonModel(true, credential.user!.uid, token));
        } else {
          // await usersRef.doc(credential.user!.uid).set(model.toJsonModel(false, credential.user!.uid, token));
        }
      }
    } catch(e) {
      throw ServerFailure(message: '$e');
    }
  }

  // @override
  // Future<Chat?> getChatByUsers(List<String> users) async {
  //   QuerySnapshot snapshot = await chatsRef.where(
  //       'memberIds', whereIn: [[users[1], users[0]]],
  //   ).get();
  //
  //   if (snapshot.docs.isEmpty) {
  //     snapshot = await chatsRef.where(
  //       'memberIds', whereIn: [[users[0], users[1]]],
  //     ).get();
  //   }
  //
  //   if (snapshot.docs.isNotEmpty) {
  //     return Chat.fromDoc(snapshot.docs[0]);
  //   }
  //   return null;
  // }
  //
  // @override
  // Future<UserModel?> getUserById(String uid) async {
  //   if (networkState.isConnected) {
  //     final document = await usersRef.doc(uid).get();
  //     if (document.exists) {
  //       final json = document.data() as Map<String, dynamic>;
  //       final user = UserModel.fromJson(json);
  //       // logger.i(user.toJsonWithOutTime());
  //       return user;
  //     } return null;
  //   } else {
  //     Get.snackbar(
  //       'oops'.tr,
  //       'error_connection'.tr,
  //       icon: Icon(MdiIcons.wifiRemove, color: Colors.red[300]),
  //       shouldIconPulse: true,
  //       barBlur: 20,
  //       isDismissible: true,
  //       duration: Duration(seconds: 4),
  //     );
  //     return null;
  //   }
  // }
  //

  // @override
  // void setChatRead(BuildContext context, Chat chat, bool read) async {
  //   String currentUserId = auth.currentUser!.uid;
  //   return chatsRef.doc(chat.id).update({
  //     'readStatus.$currentUserId': read,
  //   });
  // }

  // @override
  // void setChatGroupRead(BuildContext context, RoomModel lounges, bool read) async {
  //   String currentUserId = auth.currentUser!.uid;
  //   return roomsRef.doc(lounges.id).update({
  //     'readStatus.$currentUserId': read,
  //   });
  // }
  //
  // @override
  // Future<Chat> createChat(List<UserModel> users, List<String> userIds) async {
  //   Map<String, dynamic> readStatus = {};
  //
  //   for (UserModel user in users) {
  //     readStatus[user.uid] = false;
  //   }
  //
  //   DocumentReference res = await chatsRef.add({
  //     'recentMessage': 'Chat Created',
  //     'recentSender': '',
  //     'memberIds': userIds,
  //     'readStatus': readStatus,
  //     'recentTimestamp': FieldValue.serverTimestamp(),
  //   });
  //
  //   return Chat(
  //     id: res.id,
  //     recentMessage: 'Chat Created',
  //     recentSender: '',
  //     memberIds: userIds,
  //     readStatus: readStatus,
  //     memberInfo: users,
  //     recentTimestamp: FieldValue.serverTimestamp(),
  //   );
  // }

  // @override
  // Future<String?> uploadMessageImage(File imageFile) async {
  //   String imageId = const Uuid().v4();
  //   File? image = await compressImage(imageId, imageFile);
  //   if (image != null) {
  //     String? downloadUrl = await _uploadChatImage(image);
  //     return downloadUrl;
  //   }
  // }

  // static Future<String?> _uploadChatImage(File file) async {
  //   try {
  //
  //     String name = basename(file.path);
  //     final typeImage = name.substring(name.indexOf('.')+1, name.length);
  //
  //     print('$typeImage');
  //
  //     List<firebase_storage.UploadTask> _uploadTasks = [];
  //
  //     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("chats/${Uuid().v4()}");
  //     firebase_storage.SettableMetadata metadata = firebase_storage.SettableMetadata(
  //       contentType: 'image/$typeImage', customMetadata: {'picked-file-path': file.path},
  //     );
  //
  //     return await ref.putFile(file, metadata).then((firebase_storage.TaskSnapshot snapshot) async {
  //       return await snapshot.ref.getDownloadURL();
  //     });
  //
  //   } catch(e) {
  //     print('e: $e');
  //   }
  // }

  // @override
  // void sendChatMessage(Chat chat, Message message, UserModel receiverUser) async {
  //   final id = Uuid().v4();
  //   final ref = chatsRef.doc(chat.id).collection('messages').doc(id);
  //   await ref.set({
  //     'id': id,
  //     'senderId': message.senderId,
  //     'receiverId': message.receiverId,
  //     'text': message.text,
  //     'imageUrl': message.imageUrl,
  //     'timestamp': message.timestamp,
  //     'isLiked': message.isLiked,
  //   });
  //
  //   chatsRef.doc(chat.id).update({
  //     "recentTimestamp": FieldValue.serverTimestamp(),
  //     "recentSender": auth.currentUser!.uid,
  //     "recentMessage": message.text,
  //   });
  //
  //   /*
  //   addActivityItem(
  //     comment: message.text,
  //     currentUserId: message.senderId,
  //     isCommentEvent: false,
  //     isFollowEvent: false,
  //     isLikeEvent: false,
  //     isMessageEvent: true,
  //     post: PostModel(authorId: receiverUser!.uid),
  //     receiverToken: receiverUser.token,
  //   );
  //    */
  // }

  // @override
  // void sendChatGroupMessage({
  //   required MessageGroup message,
  //   required List<UserModel> receiverUser,
  //   required RoomModel lounge,
  // }) async {
  //   final uuid = Uuid().v4();
  //   final ref = roomsRef.doc(lounge.id).collection('messages').doc(uuid);
  //
  //   await ref.set({
  //     'id': uuid,
  //     'senderId': message.senderId,
  //     'receiverId': message.receiverId,
  //     'text': message.text,
  //     'imageUrl': message.imageUrl,
  //     'timestamp': message.timestamp,
  //     'isLiked': message.isLiked,
  //   });
  //
  //   await roomsRef.doc(lounge.id).update({
  //     "recentTimestamp": FieldValue.serverTimestamp(),
  //     "recentSender": auth.currentUser!.uid,
  //     "recentMessage": message.text,
  //   });
  //
  //   // addActivityItem(
  //   //   comment: message.text,
  //   //   currentUserId: message.senderId,
  //   //   isCommentEvent: false,
  //   //   isFollowEvent: false,
  //   //   isLikeEvent: false,
  //   //   isMessageEvent: true,
  //   //   post: PostModel(authorId: receiverUser!.uid),
  //   //   receiverToken: receiverUser.token,
  //   // );
  // }

  @override
  Future<void> likeUnlikeMessage(Message message, String chatId,
      bool isLiked, UserModel receiverUser, String currentUserId) {
    return chatsRef.doc(chatId)
        .collection('messages')
        .doc(message.id)
        .update({'isLiked': isLiked});
  }

  @override
  String parseTimestamp(dynamic timestamp) {
    try {
      logger.i(timestamp.runtimeType);
      return timeFormat.format(timestamp);
    } catch(e) {
      logger.e('$e');
      return '';
    }
  }

  @override
  Future<void> logOut(BuildContext context) async {
    try {
      LoadingDialog.show(context: context);
      if (auth.currentUser != null) {
        await removeToken();
        await auth.signOut();
      }
      // Get.overlayContext.read<ModelNotifier>().logout();
      if (context.mounted) LoadingDialog.hide(context: context);
      logger.i('logout');
    } catch(e) {
      logger.e('$e');
      if (context.mounted) LoadingDialog.hide(context: context);
      Get.snackbar(
        'oops'.tr,
        'error_wrong'.tr,
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.warning, color: Colors.red[300]),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Future<void> removeToken() async {
    final currentUser = auth.currentUser;
    await usersRef.doc(currentUser!.uid).update({'token': null});
  }

  Future<File?> croppedFile(File file) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'crop_rotate'.tr,
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(title: 'crop_rotate'.tr)
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch(e) {
      logger.e(e);
      return null;
    }
    return null;
  }
}
