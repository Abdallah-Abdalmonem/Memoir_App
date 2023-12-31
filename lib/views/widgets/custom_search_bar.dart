// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:memoir_app/controllers/home_controller.dart';
import 'package:memoir_app/models/note_model.dart';

import '../../constant/app_routes.dart';

class CustomSearchDelegate extends SearchDelegate {
  HomeController controller;
  CustomSearchDelegate({
    required this.controller,
  });
  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ];
    } else {
      return [];
    }
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<NoteModel> searchNote = [];
    if (controller.notesList.length < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text(
              "There are no nots to search.",
            ),
          )
        ],
      );
    } else {
      for (var i = 0; i < controller.notesList.length; i++) {
        if (controller.notesList[i].title!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            controller.notesList[i].note!
                .toLowerCase()
                .contains(query.toLowerCase())) {
          searchNote.add(controller.notesList[i]);
        }
      }
      if (searchNote.length < 1) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Text("there are no results.", textScaleFactor: 1.5),
            ),
          ],
        );
      } else {
        return ListView.builder(
          itemCount: searchNote.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: Color(int.parse('${searchNote[index].color}'))
                  .withOpacity(.5),
              shadowColor: Colors.red,
              elevation: 6,
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.noteScreen,
                      arguments: controller.notesList[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${searchNote[index].title}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 2),
                      const Divider(),
                      const SizedBox(height: 4),
                      Text('${searchNote[index].note}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 8),
                      const SizedBox(height: 4),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            textAlign: TextAlign.right,
                            '${searchNote[index].createdOn?.toDate().year}-${searchNote[index].createdOn?.toDate().month}-${searchNote[index].createdOn?.toDate().day}\n${searchNote[index].createdOn?.toDate().hour}:${searchNote[index].createdOn?.toDate().minute}:${searchNote[index].createdOn?.toDate().second}',
                            maxLines: 5,
                            style: const TextStyle(
                                fontSize: 14,
                                letterSpacing: 1,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<NoteModel> searchNote = [];
    if (controller.notesList.length < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text("There are no nots to search."),
          )
        ],
      );
    } else {
      for (var i = 0; i < controller.notesList.length; i++) {
        if (controller.notesList[i].title!
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            controller.notesList[i].note!
                .toLowerCase()
                .contains(query.toLowerCase())) {
          searchNote.add(controller.notesList[i]);
        }
      }
      if (searchNote.length < 1) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Text("there are no results."),
            ),
          ],
        );
      } else {
        return ListView.builder(
          itemCount: searchNote.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              color: Color(int.parse('${searchNote[index].color}'))
                  .withOpacity(.5),
              shadowColor: Colors.red,
              elevation: 6,
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.noteScreen,
                      arguments: controller.notesList[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${searchNote[index].title}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 2),
                      const Divider(),
                      const SizedBox(height: 4),
                      Text('${searchNote[index].note}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 8),
                      const SizedBox(height: 4),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              textAlign: TextAlign.right,
                              '${searchNote[index].createdOn?.toDate().year}-${searchNote[index].createdOn?.toDate().month}-${searchNote[index].createdOn?.toDate().day}\n${searchNote[index].createdOn?.toDate().hour}:${searchNote[index].createdOn?.toDate().minute}:${searchNote[index].createdOn?.toDate().second}',
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
