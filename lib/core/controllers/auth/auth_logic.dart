import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:popcorn/core/models/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../widgets_helper/loading_dialog.dart';
import '../../theme/generateMaterialColor.dart';
import 'package:flutter/material.dart';
import '../../usecases/constants.dart';
import '../../error/exceptions.dart';
import '../../error/failures.dart';
import '../../usecases/enums.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../util/img.dart';
import '../notification/notification_controller.dart';
import 'auth_state.dart';



class AuthLogic extends GetxController {
  static AuthLogic instance = Get.find();
  final state = AuthState();


  /*
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      if (networkState.isConnected) {
        GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential = await auth.signInWithCredential(credential);
          if (userCredential.user != null) {
            await updateUser(userCredential, null);
          }
          return userCredential;
        } else {
          utilsLogic.showSnack(
            type: SnackBarType.error,
            message: 'user_cancelled_login'.trArgs(['Google']),
          );
        }
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.unconnected,
        );
      }
      return null;
    } catch (e) {
      logger.e(e.toString());
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
      return null;
    }
  }



  Future<UserCredential?> signInWithEmailAndPass({
    required BuildContext context,
    required String email,
    required String pass,
  }) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        final userCredential = await auth.signInWithEmailAndPassword(email: email, password: pass);
        if (userCredential.user != null) {
          await updateUser(userCredential, pass);
        }
        LoadingDialog.hide(context: context);
        return userCredential;
      } on FirebaseAuthException catch(e) {
        LoadingDialog.hide(context: context);
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
          utilsLogic.showSnack(type: SnackBarType.error, message: 'user_not_found'.tr);
        } else if (e.code == 'wrong-password') {
          utilsLogic.showSnack(type: SnackBarType.error, message: 'pass_not_correct'.tr);
          logger.e('Wrong password provided for that user.');
        } else {
          logger.e('error: $e');
          utilsLogic.showSnack(type: SnackBarType.error, message: 'something_wrong'.tr);
        }
      }
    } else {
      utilsLogic.showSnack(type: SnackBarType.unconnected);
    }
    return null;
  }

  Future<void> updateUser(UserCredential currentUser, String? password) async {
    String? token = notificationState.token;
    final uid = currentUser.user!.uid;
    final doc = await usersRef.doc(uid).get();
    if (doc.exists) {
      await doc.reference.update({'token': token});
    } else {
      final user = UserModel(
        displayName: currentUser.user?.displayName ?? 'User',
        isVerified: currentUser.user!.emailVerified,
        timestamp: FieldValue.serverTimestamp(),
        email: currentUser.user!.email!,
        status: getIdStatusUser('actively'.tr),
        uniqueKey: utilsLogic.createUniqueId(uid),
        role: 'user',
        token: token,
        uid: uid,
        level: 0,
      );
      await usersRef.doc(uid).set(user.toJson());
    }

  }

  Future<UserCredential?> createAccount({
    required BuildContext context, required UserModel model}) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: model.email, password: model.password!,
        );
        if (userCredential.user != null) {
          await _createUser(credential: userCredential, model: model);
        }
        LoadingDialog.hide(context: context);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        LoadingDialog.hide(context: context);
        if (e.code == 'weak-password') {
          logger.e('The password provided is too weak.');
          utilsLogic.showSnack(type: SnackBarType.error, message: 'weak_password'.tr);
        } else if (e.code == 'email-already-in-use') {
          logger.e('error: $e');
          utilsLogic.showSnack(type: SnackBarType.error, message: 'email_already_use'.tr);
        } else {
          logger.e('error: $e');
          utilsLogic.showSnack(type: SnackBarType.error, message: 'something_wrong'.tr);
        }
      } catch (e) {
        LoadingDialog.hide(context: context);
        logger.e(e.toString());
        utilsLogic.showSnack(
          type: SnackBarType.error,
          message: '$e',
        );
      }
    } else {
      utilsLogic.showSnack(type: SnackBarType.unconnected, message: 'error_connection'.tr);
    }
    return null;
  }

  Future<void> _createUser({
    required UserCredential credential,
    required UserModel model,
  }) async {
    logger.i('Create new user save model');
    if (credential.user != null) {
      await usersRef.doc(credential.user!.uid).set(model.toJsonUid(
        uniqueKey: utilsLogic.createUniqueId(credential.user!.uid),
        uid: credential.user!.uid,
      ));
    } else {
      throw ServerException();
    }
  }
  */

  Future<bool> signOutDialog(BuildContext context) async {
    return await showDialog(context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Image.asset(IMG.logo2,
            height: 30, width: 30,
            color: primaryColor,
            // color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Text('logout_app'.tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyText2?.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('yes'.tr),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> signOut() async {
    userLogic.signOut();
    await auth.signOut();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
  }


  /*
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await facebookAuth.login();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
        final userCredential = await auth.signInWithCredential(facebookAuthCredential);
        if (userCredential.user != null) {
          await updateUser(userCredential, null);
        }
        return userCredential;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.error,
          message: result.message,
        );
      }
      return null;
    } catch(e) {
      logger.e(e.toString());
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
      return null;
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        await auth.sendPasswordResetEmail(email: email);
        LoadingDialog.hide(context: context);
      } on FirebaseAuthException catch (e) {
        LoadingDialog.hide(context: context);
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
          utilsLogic.showSnack(type: SnackBarType.error,
            message: 'user_not_found'.tr,
          );
        } else {
          logger.e('$e');
          utilsLogic.showSnack(type: SnackBarType.error,
            message: '$e',
          );
        }
      } catch(e) {
        LoadingDialog.hide(context: context);
        utilsLogic.showSnack(type: SnackBarType.error);
      }
    } else {
      utilsLogic.showSnack(type: SnackBarType.unconnected);
    }
  }
  */


  int getIdStatusUser(String val) {
    return statusUser.keys.firstWhere(
          (k) => statusUser[k] == val,
      orElse: () => statusUser.keys.last,
    );
  }

  Future<String?> resetPasswordDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: primaryColor,
            child: Text(
              'reset_pass'.tr,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                  labelText: 'email'.tr,
                  focusColor: primaryColor,
                  fillColor: primaryColor,
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  )
              ),
              validator: (val) {
                final field = val ?? '';
                if (field.isEmpty) {
                  return 'required_field'.tr;
                } else if (!GetUtils.isEmail(field.trim())) {
                  return 'enter_valid_email'.tr;
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'send'.tr,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, emailController.text.trim());
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String pass,
  }) async {
    if (networkState.isConnected) {
      try {
        final userCredential = await signInWithEmailAndPassword(email: email, pass: pass);
        await userLogic.updateUserToken(token: NotificationController.firebaseAppToken);
        return Right(userCredential);
      } on ServerException catch (failure) {
        return Left(ServerFailure(
          message: failure.message,
          state: failure.state,
        ));
      }
    } else {
      return Left(NetworkFailure(
        state: RequestState.network,
        message: 'error_connection'.tr,
      ));
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String pass,
    String? token,
  }) async {
    try {
      return await auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
        throw ServerException(
          state: RequestState.error,
          message: 'user_not_found'.tr,
        );
      } else if (e.code == 'wrong-password') {
        logger.e('Wrong password provided for that user.');
        throw ServerException(
          state: RequestState.error,
          message: 'pass_not_correct'.tr,
        );
      } else {
        logger.e('error: $e');
        throw Left(ServerException(
          state: RequestState.error,
          message: '$e',
        ));
      }
    } catch(e) {
      throw Left(ServerException(
        state: RequestState.error,
        message: '$e',
      ));
    }
  }

  Future<UserCredential> createNewAccount({
    required UserModel model,
  }) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: model.email, password: model.password!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.e('The password provided is too weak.');
        throw ServerException(
          state: RequestState.error,
          message: 'password_too_short'.tr,
        );
      } else if (e.code == 'email-already-in-use') {
        logger.e('error: $e');
        throw ServerException(
          state: RequestState.error,
          message: 'email_already_use'.tr,
        );
      } else {
        logger.e('error: $e');
        throw ServerException(
          state: RequestState.error,
          message: 'something_wrong'.tr,
        );
      }
    } catch (e) {
      logger.e(e.toString());
      throw ServerException(
        state: RequestState.error,
        message: '$e',
      );
    }
  }



  Future<void> sendEmailVerification(UserCredential userCredential) async {
    final context = Get.overlayContext;
    if (context != null && (userCredential.user?.emailVerified == false)) {
      await userCredential.user?.sendEmailVerification().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('verify_link_sent_your_email'.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: headlineColor),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(5),
          elevation: 10,
        ));
      });
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      if (networkState.isConnected) {
        GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final UserCredential userCredential = await auth.signInWithCredential(credential);
          if (userCredential.user != null && context.mounted) {
            await checkUserExist(
              userCredential: userCredential,
              context: context,
            );

            if (context.mounted) {
              await checkOrCreateUser(
                currentUser: userCredential,
                context: context,
              );
            }
          }
          return userCredential;
        } else {
          utilsLogic.showSnack(
            type: SnackBarType.error,
            message: 'user_cancelled_login'.trArgs(['Google']),
          );
        }
      } else {
        utilsLogic.showSnack(type: SnackBarType.unconnected);
      }
    } catch (e) {
      logger.e(e.toString());
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
    }
    return null;
  }

  Future<UserCredential?> signInWithApple(BuildContext context) async {
    try {
      if (networkState.isConnected) {
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        final userCredential = await auth.signInWithCredential(oauthCredential);
        if (userCredential.user != null && context.mounted) {
          await checkUserExist(
            userCredential: userCredential,
            context: context,
          );

          if (context.mounted) {
            await checkOrCreateUser(
              currentUser: userCredential,
              context: context,
            );
          }
        }
        return userCredential;
      } else {
        utilsLogic.showSnack(type: SnackBarType.unconnected);
      }
    } on SignInWithAppleException catch(e) {
      logger.e(e);
    } catch (e, s) {
      logger.e('login error: $e - stack: $s');
      logger.e(e.toString());
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
    }
    return null;
  }

  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await facebookAuth.login();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);
        final userCredential = await auth.signInWithCredential(facebookAuthCredential);
        if (userCredential.user != null && context.mounted) {
          await checkUserExist(
            userCredential: userCredential,
            context: context,
          );

          if (context.mounted) {
            await checkOrCreateUser(
              currentUser: userCredential,
              context: context,
            );
          }
        }
        return userCredential;
      } else {
        utilsLogic.showSnack(
          type: SnackBarType.error,
          message: result.message,
        );
      }
    } catch(e) {
      logger.e(e.toString());
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: '$e',
      );
    }
    return null;
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> checkOrCreateUser({
    required UserCredential currentUser,
    required BuildContext context,
  }) async {
    try {
      LoadingDialog.show(context: context);
      final uid = currentUser.user!.uid;
      final response = await apiClient.putData(
        url: '$baseUrlApi/v1/user/check-create/$uid',
        data: UserModel(
          displayName: currentUser.user?.displayName ?? 'User',
          isVerified: currentUser.user!.emailVerified,
          email: currentUser.user!.email!,
          createdAt: DateTime.now(),
          lastSeen: DateTime.now(),
          hideIntro: false,
          isBanned: false,
          role: 'user',
          token: null,
          blocks: [],
          uid: uid,
        ).toJson(),
      );
      logger.i('Updated User: ${response.statusCode}');
      if (context.mounted) LoadingDialog.hide(context: context);
    } on ServerException catch (failure) {
      if (context.mounted) LoadingDialog.hide(context: context);
      throw ServerException(
        state: RequestState.error,
        message: failure.message,
      );
    }
  }


  Future<void> checkUserExist({
    required BuildContext context,
    required UserCredential userCredential,
  }) async {
    try {
      final url = '$baseUrlApi/v1/user/get/${userCredential.user?.uid}';
      final response = await apiClient.getData(url: url);
      if (response.statusCode != 200) {
        await sendEmailVerification(userCredential);
      }
    } on ServerException catch(failure) {
      utilsLogic.showSnack(
        type: SnackBarType.error,
        message: failure.message,
      );
    }
  }

  Future<bool> resetPassword(BuildContext context, String email) async {
    if (networkState.isConnected) {
      try {
        LoadingDialog.show(context: context);
        await auth.sendPasswordResetEmail(email: email);
        if (context.mounted) LoadingDialog.hide(context: context);
        return true;
      } on FirebaseAuthException catch (e) {
        if (context.mounted) LoadingDialog.hide(context: context);
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
          utilsLogic.showSnack(type: SnackBarType.error,
            message: 'user_not_found'.tr,
          );
        } else {
          logger.e('$e');
          utilsLogic.showSnack(type: SnackBarType.error,
            message: '$e',
          );
        }
      } catch(e) {
        if (context.mounted) LoadingDialog.hide(context: context);
        utilsLogic.showSnack(type: SnackBarType.error);
      }
    } else {
      utilsLogic.showSnack(type: SnackBarType.unconnected);
    }
    return false;
  }

  Future<Either<Failure, UserCredential>> createAccount({
    required BuildContext context,
    required UserModel model,
  }) async {
    if (networkState.isConnected) {
      try {
        final userCredential = await createNewAccount(model: model);
        if (userCredential.user != null) {
          final uid = userCredential.user!.uid;
          await sendEmailVerification(userCredential);
          await createNewUser(model.copyWith(uid: uid));
        }
        return Right(userCredential);
      } on ServerException catch (failure) {
        return Left(ServerFailure(
          message: failure.message,
          state: failure.state,
        ));
      }
    } else {
      return Left(NetworkFailure(
        state: RequestState.network,
        message: 'error_connection'.tr,
      ));
    }
  }

  Future<void> createNewUser(UserModel model) async {
    try {
      if (kDebugMode) {
        logger.i('createNewUser');
      }
      final response = await apiClient.postData(
        url: '$baseUrlApi/v1/user/create',
        data: model.toJson(),
      );
      if (kDebugMode) {
        logger.i('Create new user status: ${response.statusCode}, ${response.body}');
      }
    } on ServerException catch (failure) {
      throw ServerException(
        state: RequestState.error,
        message: failure.message,
      );
    }
  }

}