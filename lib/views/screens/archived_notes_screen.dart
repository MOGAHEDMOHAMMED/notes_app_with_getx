import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/core/l10n/app_localizations.dart';
import 'package:notes_app_with_getx/core/routes/app_routes.dart';
import 'package:notes_app_with_getx/controllers/notes_provider.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';
import 'package:provider/provider.dart';

import '../../controllers/ui_state_provider.dart';
import '../widget/app_drawer.dart';

// ignore: must_be_immutable
class ArchivedNotesScreen extends StatelessWidget {
  const ArchivedNotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.archivedNotesAppBar),
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

      drawer: AppDrawer(currentScreen: AppRoutes.archivedNotesScreen),

      body: Obx(
        () => notesController.archivedNotes.isEmpty
            ? CenterIfNotesEmpty(
                icon: Icons.note_add_outlined,
                message: AppLocalizations.of(context)!.noArchivedNotes,
              )
            : NotesGridView(notes: notesController.archivedNotes),
      ),
      floatingActionButton: HelperMethods.addNoteButton(
        context,
        status: "archived",
      ),
    );
  }
}
