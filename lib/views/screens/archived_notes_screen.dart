import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/core/app_routes.dart';
import 'package:notes_app_with_getx/controllers/notes_controller.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';
import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import '../widget/app_drawer.dart';

// ignore: must_be_immutable
class ArchivedNotesScreen extends StatelessWidget {
  const ArchivedNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('archivedNotesAppBar'.tr),
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

      drawer: AppDrawer(currentScreen: AppRoutes.archivedNotesScreen),

      body: Obx(
        () => notesController.archivedNotes.isEmpty
            ? CenterIfNotesEmpty(
                icon: Icons.note_add_outlined,
                message: 'noArchivedNotes'.tr,
              )
            : NotesGridView(notes: notesController.archivedNotes),
      ),
      floatingActionButton: HelperMethods.addNoteButton(status: "archived"),
    );
  }
}
