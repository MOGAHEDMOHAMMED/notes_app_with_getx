import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/core/routes/app_routes.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import 'package:notes_app_with_getx/views/screens/note_details.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/app_localizations.dart';
import '../../models/note_model.dart';
import '../../controllers/notes_provider.dart';
import '../screens/choose_note_category.dart';

class HelperMethodsGetx {
  static Future<dynamic> showErrorDialog(String error) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: Colors.red.shade200,
        title: const Icon(Icons.error, color: Colors.red, size: 40),
        content: Text(error, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "ok",
              // AppLocalizations.of(context)!.okButton
            ),
          ),
        ],
      ),
    );
  }
}

class HelperMethods extends StatelessWidget {
  const HelperMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Icon(Icons.error, color: Colors.red, size: 40),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.okButton),
          ),
        ],
      ),
    );
  }

  static void showNoteOptions(BuildContext context, NoteModel note) {
    final tr = AppLocalizations.of(context)!;
    final notesController = Get.find<NotesController>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${tr.lastUpdate} ${note.lastUpdate!.year}/${note.lastUpdate!.month}/${note.lastUpdate!.day}",
                  textAlign: TextAlign.start,
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.archive_outlined,
                    color: Colors.blue,
                  ),
                  title: Text(
                    note.status == 'archived'
                        ? tr.moveFromArchive
                        : tr.moveToArchived,
                    textAlign: TextAlign.start,
                  ),
                  onTap: () {
                    notesController.moveNote(
                      note,
                      note.status == 'archived' ? 'active' : 'archived',
                    );
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.copy, color: Colors.blue),
                  title: Text(tr.duplicate),
                  onTap: () {
                    notesController.addNote(note.title, note.content);
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.label_outline, color: Colors.blue),
                  title: Text(tr.category),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectCategoryScreen(note: note),
                      ),
                    );
                  },
                ),
                !(note.status == 'deleted')
                    ? ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        title: Text(tr.moveToRecycleBin),
                        onTap: () {
                          notesController.moveNote(note, 'deleted'); //
                          Navigator.pop(context);
                        },
                      )
                    : ListTile(
                        leading: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                        ),

                        title: Text(tr.deleteForever),
                        onTap: () {
                          notesController.deleteForever(note.id);
                          Navigator.pop(context);
                        },
                      ),
                note.status == "deleted"
                    ? ListTile(
                        leading: const Icon(
                          Icons.redo_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(tr.recoveryNote),
                        onTap: () {
                          notesController.moveNote(note, "active");
                        },
                      )
                    : Text(""),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: Text(tr.shareNote),
                  onTap: () {
                    if (note.content.isEmpty) {
                      HelperMethods.showErrorDialog(
                        context,
                        tr.emptyContentShare,
                      );
                      Navigator.pop(context);
                      return;
                    }
                    String shareContent =
                        "${note.title}\n\n------------\n${note.content} \n\n-----------\n${tr.sharedVia} www.dwaen.com";
                    HelperMethods.shareNote(shareContent);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void shareNote(String content) {
    SharePlus.instance.share(ShareParams(text: content));
  }

  static FloatingActionButton addNoteButton(
    BuildContext context, {
    String status = "active",
    CategoryModel? categoryModel,
  }) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        NoteModel? emptyNote = Get.find<NotesController>().emptyNote(
          status: status,
          categoryModel: categoryModel,
        );
        Get.to(() => NoteDetails(note: emptyNote!, isNewNote: true));
      },
    );
  }

  static ScaffoldFeatureController showSnackbarWithOutActions(
    BuildContext context,
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
