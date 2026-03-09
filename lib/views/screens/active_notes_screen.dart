import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import 'package:notes_app_with_getx/views/widget/app_drawer.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';

import 'package:notes_app_with_getx/controllers/notes_controller.dart';

class ActiveNoteScreen extends StatelessWidget {
  const ActiveNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle'.tr),
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
      drawer: AppDrawer(
        currentScreen: ModalRoute.of(context)?.settings.name ?? '',
      ),
      body: Obx(
        () => notesController.activeNotes.isEmpty
            ? CenterIfNotesEmpty(
                icon: Icons.edit_note,
                message: 'noActiveNotes'.tr,
              )
            : NotesGridView(notes: notesController.activeNotes),
      ),

      floatingActionButton: HelperMethods.addNoteButton(),
    );
  }
}
