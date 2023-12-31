import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../constant/app_keys.dart';
import '../helper/cache_helper.dart';
import '../services/image_service.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../helper/toast_helper.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  late final TextEditingController titleEditingController;
  late final TextEditingController noteEditingController;
  late final TextEditingController editTitleEditingController;
  late final TextEditingController editNoteEditingController;

  GlobalKey<FormState> homeKey = GlobalKey<FormState>();
  String? imageUrl;

  List<Color> colorList = [
    Colors.black,
    Colors.pink.withOpacity(.5),
    Colors.green.withOpacity(.2),
    Colors.purpleAccent.withOpacity(.2),
    Colors.purple.withOpacity(.5),
    Colors.yellow.withOpacity(.5),
    Colors.black.withOpacity(.5),
    Colors.green.withOpacity(.5),
    Colors.grey.withOpacity(.5),
    Colors.orange.withOpacity(.5),
    Colors.brown.withOpacity(.5),
    Colors.blue.withOpacity(.5),
  ];
  Color selectedColor = Colors.black;
  Color editColor = Colors.black;

  List<NoteModel> notesList = [];

  User? currentUser = FirebaseAuth.instance.currentUser;
  bool userHasInformation = false;

  @override
  void onInit() {
    UserService.getUserInformation().then((value) {
      if (value.length > 0) {
        userHasInformation = true;
      }
    });

    String? s = CacheHelper.prefs?.getString(AppKeys.image_profile);
    if (s != null) {
      imageUrl = s;
    }

    titleEditingController = TextEditingController();
    noteEditingController = TextEditingController();

    editTitleEditingController = TextEditingController();
    editNoteEditingController = TextEditingController();
    super.onInit();
  }

  Future<List<NoteModel>?> getNotes() async {
    notesList.clear();
    List<NoteModel> response = await NoteService.getNotes();
    notesList = response;

    if (response.length > 0) {
      print('get note');
      print(response.length);
      return response;
    }
  }

  Future<void> addNote() async {
    if (homeKey.currentState!.validate()) {
      try {
        NoteModel noteModel = NoteModel(
          title: titleEditingController.text,
          note: noteEditingController.text,
          color: selectedColor.toString(),
          createdOn: Timestamp.now(),
          userId: FirebaseAuth.instance.currentUser?.uid,
        );
        await NoteService.addNote(noteModel: noteModel).then((value) {
          // if (value != null || value != '') {
          clearTextFormField(); // to clear textformfield
          update();
          // }
        });
      } catch (e) {
        ToastHelper.toastfailure(msg: e.toString());
        print(e);
      }
    }
  }

  Future<void> deleteNote(String noteId) async {
    await NoteService.deleteNote(noteId);
    update();
  }

  Future<void> deleteAllNote() async {
    print('delete all note');
    if (notesList.isNotEmpty) {
      await NoteService.deleteAllNote();
      notesList.clear();
      // await getNotes();
      update();
      ToastHelper.toastSuccess(msg: 'delete all notes success');
    } else {
      ToastHelper.toastfailure(msg: 'There is no notes');
    }
  }

  Future<void> editNote(NoteModel oldNoteModel) async {
    NoteModel noteModel;
    noteModel = NoteModel(
      userId: FirebaseAuth.instance.currentUser?.uid,
      noteId: oldNoteModel.noteId,
      title: editTitleEditingController.text,
      note: editNoteEditingController.text,
      color: editColor.toString(),
      createdOn: oldNoteModel.createdOn,
      editOn: Timestamp.now(),
    );
    await NoteService.editNote(
        noteId: oldNoteModel.noteId.toString(), noteModel: noteModel);

    clearTextFormField();
    update();
  }

  clearTextFormField() {
    titleEditingController.text = '';
    noteEditingController.text = '';

    editTitleEditingController.text = '';
    editNoteEditingController.text = '';
  }

  Future removeProfileImage() async {
    String? imageName = CacheHelper.prefs?.getString(AppKeys.image_name);
    await FirebaseStorage.instance.ref('image/profile/$imageName').delete();
    await CacheHelper.prefs
        ?.remove(AppKeys.image_profile)
        .then((value) => imageUrl = null);
    update();
  }

  uploadImage() async {
    XFile? image = await ImageServices.pickImageFromCamera();

    if (image != null) {
      String imageName = basename(image.path);
      Reference refStorage =
          FirebaseStorage.instance.ref('image/profile/$imageName');

      File? file = File(image.path);

      ToastHelper.toastSuccess(msg: 'please wait to upload photo');
      await refStorage.putFile(file);
      imageUrl = await refStorage.getDownloadURL();
      await CacheHelper.prefs?.setString(AppKeys.image_name, '$imageName');
      await CacheHelper.prefs?.setString(AppKeys.image_profile, '$imageUrl');
      update();
    } else {
      ToastHelper.toastfailure(msg: 'Please Choose Image');
    }
  }

  Future<void> refreshScreen() async {
    await Future.delayed(const Duration(seconds: 2), () => getNotes());
    update();
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    noteEditingController.dispose();

    editTitleEditingController.dispose();
    editNoteEditingController.dispose();
    super.dispose();
  }
}
