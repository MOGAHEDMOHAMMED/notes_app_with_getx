import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:notes_app_with_getx/views/screens/note_details.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import '../../models/note_model.dart';
import '../../controllers/notes_controller.dart';
import '../screens/choose_note_category.dart';

class HelperMethods {
  static void showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Icon(Icons.error, color: Colors.red, size: 40),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('okButton'.tr)),
        ],
      ),
    );
  }

  static void showNoteOptions(NoteModel note) {
    final notesController = Get.find<NotesController>();
    Get.bottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Container(
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
                "${'lastUpdate'.tr} ${note.lastUpdate!.year}/${note.lastUpdate!.month}/${note.lastUpdate!.day}",
                textAlign: TextAlign.start,
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.archive_outlined, color: Colors.blue),
                title: Text(
                  note.status == 'archived'
                      ? 'moveFromArchive'.tr
                      : 'moveToArchived'.tr,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  notesController.moveNote(
                    note,
                    note.status == 'archived' ? 'active' : 'archived',
                  );
                  Get.back();
                },
              ),

              ListTile(
                leading: const Icon(Icons.copy, color: Colors.blue),
                title: Text('duplicate'.tr),
                onTap: () {
                  notesController.addNote(note.title, note.content);
                  Get.back();
                },
              ),

              ListTile(
                leading: const Icon(Icons.label_outline, color: Colors.blue),
                title: Text('category'.tr),
                onTap: () {
                  Get.to(() => SelectCategoryScreen(note: note));
                },
              ),
              !(note.status == 'deleted')
                  ? ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: Text('moveToRecycleBin'.tr),
                      onTap: () {
                        notesController.moveNote(note, 'deleted'); //
                        Get.back();
                      },
                    )
                  : ListTile(
                      leading: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),

                      title: Text('deleteForever'.tr),
                      onTap: () {
                        notesController.deleteForever(note.id);
                        Get.back();
                      },
                    ),
              note.status == "deleted"
                  ? ListTile(
                      leading: const Icon(
                        Icons.redo_outlined,
                        color: Colors.blue,
                      ),
                      title: Text('recoveryNote'.tr),
                      onTap: () {
                        notesController.moveNote(note, "active");
                      },
                    )
                  : Text(""),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text('shareNote'.tr),
                onTap: () {
                  if (note.content.isEmpty) {
                    HelperMethods.showErrorDialog('emptyContentShare'.tr);
                    Get.back();
                    return;
                  }
                  String shareContent =
                      "${note.title}\n\n------------\n${note.content} \n\n-----------\n${'sharedVia'.tr} www.dwaen.com";
                  HelperMethods.shareNote(shareContent);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void shareNote(String content) {
    SharePlus.instance.share(ShareParams(text: content));
  }

  static FloatingActionButton addNoteButton({
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
        Get.to(() => NoteDetails(note: emptyNote!, isNewNote: true,));
      },
    );
  }

  static SnackbarController showSnackbarWithOutActions(String message) {
    return Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      borderRadius: 12,
      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
      colorText: Get.theme.snackBarTheme.contentTextStyle?.color,
      barBlur: 10,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
