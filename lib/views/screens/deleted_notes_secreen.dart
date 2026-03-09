import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/notes_controller.dart';
import 'package:notes_app_with_getx/core/app_routes.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';
import '../widget/app_drawer.dart';

// ignore: must_be_immutable
class DeletedNotesScreen extends StatelessWidget {
  const DeletedNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('deletedNoteAppBar'.tr),
        actions: [
          Obx(() {
            bool isGrid = Get.find<UIStateController>().isGrid;
            return IconButton(
              onPressed: () {
                Get.find<UIStateController>().toggleGrid();
              },
              icon: Icon(isGrid ? Icons.view_agenda_outlined : Icons.grid_view),
            );
          }),
          SizedBox(width: 10),
        ],
      ),

      drawer: AppDrawer(currentScreen: AppRoutes.deletedNotesScreen),

      body: Obx(
        () => notesController.deletedNotes.isEmpty
            ? CenterIfNotesEmpty(
                icon: Icons.note_add_outlined,
                message: 'noDeletedNote'.tr,
              )
            : NotesGridView(notes: notesController.deletedNotes),
      ),
      floatingActionButton: HelperMethods.addNoteButton(status: "deleted"),
    );
  }
}
