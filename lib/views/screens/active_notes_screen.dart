import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/ui_state_provider.dart';
import 'package:notes_app_with_getx/views/widget/app_drawer.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:notes_app_with_getx/core/l10n/app_localizations.dart';
import 'package:notes_app_with_getx/controllers/notes_provider.dart';

class ActiveNoteScreen extends StatelessWidget {
  const ActiveNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          Selector<UIStateProvider, bool>(
            selector: (context, UIStateProvider state) => state.isGrid,
            builder: (context, isGrid, child) => IconButton(
              onPressed: () {
                if (isGrid) {
                  context.read<UIStateProvider>().toggleGrid();
                } else {
                  context.read<UIStateProvider>().toggleGrid();
                }
              },
              icon: Icon(isGrid ? Icons.view_agenda_outlined : Icons.grid_view),
            ),
          ),
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
                message: AppLocalizations.of(context)!.noActiveNotes,
              )
            : NotesGridView(notes: notesController.activeNotes),
      ),

      floatingActionButton: HelperMethods.addNoteButton(context),
    );
  }
}
