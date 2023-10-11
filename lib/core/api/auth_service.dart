// import 'package:popcorn/core/usecases/firebase_notifications.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:popcorn/core/usecases/firebase_service.dart';
// import 'package:ms_material_color/ms_material_color.dart';
// import 'package:popcorn/core/network/network_info.dart';
// import 'package:popcorn/core/ui/loading_dialog.dart';
// import 'package:popcorn/core/util/flash_helper.dart';
// import 'package:popcorn/core/models/user_model.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:popcorn/features/constants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:get/get.dart';
//
//
// class AuthService {
//
//   // static final firebaseUtil = GetIt.I.get<FirebaseService>();
//
//
//
//   Future<UserCredential> signInWithGoogle(BuildContext context) async {
//
//     if (networkState.isConnected) {
//       // Trigger the authentication flow
//       final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//       GoogleSignInAuthentication googleAuth;
//       // Obtain the auth details from the request
//       try {
//         googleAuth = await googleUser.authentication;
//       } catch(e) {
//         return null;
//       }
//
//       if (googleAuth == null) {
//         return null;
//       }
//
//       // Create a new credential
//       final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       // Once signed in, return the UserCredential
//       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       LoadingDialog.show(context);
//       await _createUser(userCredential);
//       LoadingDialog.hide(context);
//       return userCredential;
//     } else {
//       FlashHelper.infoBar(context, message: 'error_connection'.tr);
//       return null;
//     }
//   }
//
//   Future<UserCredential> signInWithFacebook(BuildContext context) async {
//     try {
//       if (networkState.isConnected) {
//         /*
//
//         // Trigger the sign-in flow
//         final LoginResult result = await FacebookAuth.instance.login();
//
//         // Create a credential from the access token
//         final FacebookAuthCredential facebookAuthCredential =
//         FacebookAuthProvider.credential(result.accessToken.token);
//
//         // Once signed in, return the UserCredential
//         final userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//         LoadingDialog.show(context);
//         await _createUser(userCredential);
//         LoadingDialog.hide(context);
//         return userCredential;
//
//          */
//       } else {
//         FlashHelper.infoBar(context, message: 'error_connection'.tr);
//         return null;
//       }
//     } catch(e) {
//       FlashHelper.infoBar(context, message: 'something_wrong'.tr);
//       print('error signInWithFacebook: $e');
//       return null;
//     }
//   }
//
//   Future<UserCredential> createAccount({
//     BuildContext context, String username, String email, String pass}) async {
//     if (networkState.isConnected) {
//       try {
//         LoadingDialog.show(context);
//         UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: email, password: pass,
//         );
//         await _singUpUser(userCredential, username);
//         LoadingDialog.hide(context);
//         return userCredential;
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'weak-password') {
//           print('The password provided is too weak.');
//           LoadingDialog.hide(context);
//           FlashHelper.errorBar(context, message: 'weak_password'.tr);
//         } else if (e.code == 'email-already-in-use') {
//           print('The account already exists for that email');
//           LoadingDialog.hide(context);
//           FlashHelper.errorBar(context, message: 'email_already_use'.tr);
//         } else {
//           print('error --> $e');
//           LoadingDialog.hide(context);
//           FlashHelper.errorBar(context, message: 'something_wrong'.tr);
//         }
//       } catch (e) {
//         LoadingDialog.hide(context);
//         FlashHelper.errorBar(context, message: 'something_wrong'.tr);
//       }
//     } else {
//       FlashHelper.errorBar(context, message: 'error_connection'.tr);
//     }
//   }
//
//   Future<void> _singUpUser(UserCredential credential, String username) async {
//     if (credential != null) {
//       UserModel model = UserModel(
//         role: 'user',
//         idGender: 3,
//         uid: credential.user.uid,
//         email: credential.user.email,
//         username: username,
//         token: await FirebaseNotifications.getToken() ?? '',
//       );
//       final document = await usersRef.doc(credential.user.uid).get();
//       if (document.exists ?? false) {
//         await usersRef.doc(credential.user.uid).update(model.toJsonModel(true));
//       } else {
//         await usersRef.doc(credential.user.uid).set(model.toJsonModel(false));
//       }
//     }
//   }
//
//   Future<void> _createUser(UserCredential credential) async {
//     if (credential != null) {
//       UserModel model = UserModel(
//         role: 'user',
//         idGender: 3,
//         uid: credential.user.uid,
//         email: credential.user.email,
//         username: credential.user.displayName,
//         photoURL: credential.user.photoURL,
//         token: await FirebaseNotifications.getToken() ?? '',
//       );
//       final document = await usersRef.doc(credential.user.uid).get();
//       if (document.exists ?? false) {
//         await usersRef.doc(credential.user.uid).update(model.toJsonModel(true));
//       } else {
//         await usersRef.doc(credential.user.uid).set(model.toJsonModel(false));
//       }
//     }
//   }
//
//   Future<void> resetPassword(BuildContext context) async {
//     final TextEditingController _email = new TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//     await showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         titlePadding: const EdgeInsets.all(0),
//         buttonPadding: const EdgeInsets.all(0),
//         title: Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Text('reset_pass'.tr,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           color: MsMaterialColor(kTaigaColor),
//         ),
//         content: Form(
//           key: _formKey,
//           child: TextFormField(
//             autofocus: true,
//             controller: _email,
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(color: MsMaterialColor(kTaigaColor),
//                 fontFamily: 'SFPro-Regular'
//             ),
//             cursorColor: MsMaterialColor(kOrangeColor),
//             decoration: InputDecoration(
//               labelText: 'email_address'.tr,
//               labelStyle: TextStyle(
//                 fontFamily: 'SFPro-Thin',
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//               ),
//               focusColor: MsMaterialColor(kTaigaColor),
//               fillColor: MsMaterialColor(kTaigaColor),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: MsMaterialColor(kTaigaColor),
//                 ),
//               ),
//             ),
//             validator: (val) {
//               if(val.isEmpty) {
//                 return 'required_field'.tr;
//               } else if (!GetUtils.isEmail(val)) {
//                 return 'email_invalid'.tr;
//               } else return null;
//             },
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('cancel'.tr,
//               style: TextStyle(
//                 color: MsMaterialColor(kTaigaColor),
//               ),
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           FlatButton(
//             child: Text('send'.tr,
//               style: TextStyle(
//                 color: MsMaterialColor(kTaigaColor),
//               ),
//             ),
//             onPressed: () async {
//               if (_formKey.currentState.validate()) {
//                 try {
//                   LoadingDialog.show(context);
//                   await firebaseUtil.auth.sendPasswordResetEmail(email: _email.text.trim());
//                   LoadingDialog.hide(context);
//                   Navigator.pop(context);
//                   FlashHelper.successBar(context, message: 'check_email'.tr);
//                 }  on FirebaseAuthException catch (e) {
//                   if (e.code == 'user-not-found') {
//                     print('No user found for that email.');
//                     LoadingDialog.hide(context);
//                     FlashHelper.errorBar(context, message: 'user_not_found'.tr);
//                   } else {
//                     print('error --> $e');
//                     LoadingDialog.hide(context);
//                     FlashHelper.errorBar(context, message: 'something_wrong'.tr);
//                   }
//                 } catch(e) {
//                   print('error --> $e');
//                   LoadingDialog.hide(context);
//                   FlashHelper.errorBar(context, message: 'something_wrong'.tr);
//                 }
//               }
//             },
//           ),
//         ],
//       );
//     });
//   }
//
//   Future<UserCredential> signInWithEmailAndPass({BuildContext context, String email, String pass}) async {
//     try {
//       LoadingDialog.show(context);
//       UserCredential userCredential = await firebaseUtil.auth.signInWithEmailAndPassword(email: email, password: pass);
//       if (userCredential != null) {
//         await updateToken(userCredential);
//       }
//       LoadingDialog.hide(context);
//       return userCredential;
//     } on FirebaseAuthException catch(e) {
//       LoadingDialog.hide(context);
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//         FlashHelper.errorBar(context, message: 'user_not_found'.tr);
//       } else if (e.code == 'wrong-password') {
//         FlashHelper.errorBar(context, message: 'pass_not_correct'.tr);
//         print('Wrong password provided for that user.');
//       } else {
//         print('error --> $e');
//         FlashHelper.errorBar(context, message: 'something_wrong'.tr);
//       }
//     }
//   }
//
//   Future<void> logout() async {
//     await removeToken();
//     Future.wait([
//       firebaseUtil.auth.signOut(),
//     ]);
//   }
//
//   static Future<void> removeToken() async {
//     final user = firebaseUtil.currentUser;
//     await usersRef.doc(user.uid).update({'token': ''});
//   }
//
//   static Future<void> updateToken(UserCredential currentUser) async {
//     final token = await FirebaseNotifications.getToken();
//     final userDoc = await usersRef.doc(currentUser.user.uid).get();
//     if (userDoc.exists) {
//       UserModel user = userModelFromJson(userDoc.data());
//       if (token != user.token) {
//         await usersRef.doc(currentUser.user.uid).update({'token': token});
//       }
//     }
//   }
// }