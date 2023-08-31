import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageScreen extends StatelessWidget {
  ImageScreen({super.key});
  final String image = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30)),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: image.isURL
                ? Image.network(
                    '${image}',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                : Image.asset(image, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
