import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../constant/app_image.dart';
import '../../models/note_model.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});
  final NoteModel noteData = Get.arguments;

  late final ValueNotifier<double> fontSizeValue = ValueNotifier<double>(16);

  bool isArabic() {
    if (noteData.note![0].codeUnits[0] >= 0x0600 &&
        noteData.note![0].codeUnits[0] <= 0x06E0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(int.parse('${noteData.color}')).withOpacity(.9),
      appBar: AppBar(
        leadingWidth: 30,
        toolbarHeight: MediaQuery.of(context).size.height * .06,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.bottomSheet(Container(
                  height: 200,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Text('Font Size', textScaleFactor: 2),
                      const Spacer(),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Color(int.parse('${noteData.color}'))
                                    .withOpacity(1),
                            radius: 30,
                            child: ValueListenableBuilder<double>(
                              valueListenable: fontSizeValue,
                              builder: (context, value, child) => Text(
                                '${fontSizeValue.value.toInt()}',
                                textScaleFactor: 2,
                                style: const TextStyle(color: Colors.white),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          ValueListenableBuilder<double>(
                            valueListenable: fontSizeValue,
                            builder: (context, value, child) => Slider(
                                max: 100,
                                min: 10,
                                value: fontSizeValue.value,
                                onChanged: (value) {
                                  fontSizeValue.value = value;
                                }),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ));
              },
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              onPressed: () async {
                await Share.share('Look To My Note!', subject: noteData.note);
              },
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              )),
        ],
        title: Text(
          '${noteData.title}',
          style: const TextStyle(
              fontSize: 16, letterSpacing: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              AppImage.backgroundAuth,
              fit: BoxFit.fill,
              opacity: const AlwaysStoppedAnimation(.8),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    children: [
                      ValueListenableBuilder<double>(
                        valueListenable: fontSizeValue,
                        builder: (context, value, child) => SelectableText(
                          maxLines: null,
                          textDirection: isArabic()
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          '${noteData.note}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeValue.value,
                              letterSpacing: 4,
                              wordSpacing: 3,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
