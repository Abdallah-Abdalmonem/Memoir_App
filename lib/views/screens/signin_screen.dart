import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_image.dart';
import 'package:get/get.dart';

import '../../constant/app_routes.dart';
import '../../controllers/signin_controller.dart';
import '../widgets/auth_continer.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SigninController controller = Get.put(SigninController());

    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.grey[200],
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
        title: const Text('Memoir', style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: controller.signInKey,
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                AppImage.backgroundAuth,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: AuthContiner(
                  emailTextEditingController: controller.emailController,
                  passwordTextEditingController: controller.passwordController,
                  navigateText: 'Sign up',
                  tapNavigation: () {
                    controller.clearTextFormField();
                    Get.offAllNamed(AppRoutes.signup);
                  },
                  onPress: () async {
                    await controller.signIn();
                    controller.clearTextFormField();
                  },
                  title: 'Sign in',
                  heightScreen: heightScreen,
                  widthtScreen: widthScreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
