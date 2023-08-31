import 'package:flutter/material.dart';
import '../../constant/app_image.dart';
import '../../controllers/signup_controller.dart';
import 'package:get/get.dart';

import '../../constant/app_routes.dart';
import '../widgets/auth_continer.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.put(SignupController());

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
        key: controller.signUpKey,
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
                  nameTextEditingController: controller.nameController,
                  heightScreen: heightScreen,
                  widthtScreen: widthScreen,
                  title: 'Sign up',
                  navigateText: 'login',
                  tapNavigation: () {
                    controller.clearTextFormField();
                    Get.offAllNamed(AppRoutes.signin);

                    print('i navigate to signIn');
                  },
                  onPress: () async {
                    await controller.signUp();
                    controller.clearTextFormField();
                    controller.nameController.clear();
                    Get.offAllNamed(AppRoutes.signin);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
