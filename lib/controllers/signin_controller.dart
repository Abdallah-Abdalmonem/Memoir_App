import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../constant/app_image.dart';
import '../constant/app_routes.dart';
import '../helper/cache_helper.dart';
import '../helper/toast_helper.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  GlobalKey<FormState> signInKey = GlobalKey<FormState>();

  @override
  void onReady() {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offAllNamed(AppRoutes.home);
      }
    } on Exception catch (e) {
      ToastHelper.toastfailure(msg: e.toString());
      print(e);
    }
    super.onReady();
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.onInit();
  }

  Future<void> signIn() async {
    UserCredential? credential;
    UserModel? userModel;
    if (signInKey.currentState!.validate()) {
      try {
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (credential.user!.emailVerified) {
          if (credential.user?.metadata.creationTime ==
              credential.user?.metadata.lastSignInTime) {
            userModel = UserModel(
                userId: FirebaseAuth.instance.currentUser?.uid,
                displayName: CacheHelper.prefs?.getString('display_name'),
                email: credential.user?.email,
                image: AppImage.icon);
            await UserService.uploadUserInformation(userModel: userModel);

            await CacheHelper.prefs?.remove('display_name');
          }
          await UserService.getUserInformation();
          await Get.offAllNamed(AppRoutes.home);
          ToastHelper.toastSuccess(msg: 'signin success!!');
        } else {
          ToastHelper.toastfailure(
              msg: 'Please verifiy your email by going to your email');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          ToastHelper.toastfailure(msg: 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          ToastHelper.toastfailure(
              msg: 'Wrong password provided for that user');
        }
      } catch (e) {
        print(e);
        ToastHelper.toastfailure(msg: '$e');
      }
    }
  }

  clearTextFormField() {
    emailController.text = '';
    passwordController.text = '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    signInKey.currentState?.dispose();
    super.dispose();
  }
}
