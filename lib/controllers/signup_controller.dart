import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/toast_helper.dart';
import 'package:get/get.dart';

import '../helper/cache_helper.dart';

class SignupController extends GetxController {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    super.onInit();
  }

  Future<void> signUp() async {
    UserCredential? userCredential;
    if (signUpKey.currentState!.validate()) {
      try {
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (!userCredential.user!.emailVerified) {
          await CacheHelper.prefs
              ?.setString('display_name', nameController.text);

          await userCredential.user!.sendEmailVerification();
          ToastHelper.toastSuccess(msg: 'Please confirm your email');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          ToastHelper.toastfailure(msg: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          ToastHelper.toastfailure(
              msg: 'The account already exists for that email.');
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
    nameController.dispose();
    super.dispose();
  }
}
