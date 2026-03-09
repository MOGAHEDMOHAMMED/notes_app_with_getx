// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/models/note_model.dart';
import 'package:notes_app_with_getx/controllers/notes_controller.dart';

class NoteDetails extends StatefulWidget {
  final NoteModel? note;
  final bool isNewNote;

  const NoteDetails({super.key, this.note, this.isNewNote = false});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? "");
    contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final title = titleController.text.trim();
        final content = contentController.text.trim();
        if (widget.isNewNote) {
          if (title.isEmpty && content.isEmpty) {
            HelperMethods.showSnackbarWithOutActions( 'ignoreNotes'.tr);
            Navigator.pop(context);
            return;
          } else {
            CategoryModel? cat;
            if (widget.note!.categoryId != null) {
              cat = CategoryModel(
                id: widget.note!.categoryId!,
                name: widget.note!.categoryName!,
                color: widget.note!.categoryColor!,
              );
            }
            notesController.addNote(
              title,
              content,
              status: widget.note?.status ?? "active",
              category: cat,
            );
            HelperMethods.showSnackbarWithOutActions( 'save'.tr);
          }
        } else {
          if (widget.note!.title != title || widget.note!.content != content) {
            notesController.updateNote(widget.note!, title, content);
            HelperMethods.showSnackbarWithOutActions( 'updateNote'.tr);
          }
        }
         if(context.mounted)Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNewNote ? 'newNote'.tr : 'editNote'.tr),
          actions: [
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              onPressed: () async {
                if (widget.note!.status == "archived") {
                  await notesController.moveNote(
                    widget.note!,
                    "active",
                  );
                  Get.back();
                  HelperMethods.showSnackbarWithOutActions(
                    'unArchivedSuccess'.tr,
                  );
                } else {
                  await notesController.moveNote(
                    widget.note!,
                    "archived",
                  );
                  Get.back();
                  HelperMethods.showSnackbarWithOutActions(
                    'archivedSuccess'.tr,
                  );
                }
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent.shade100,
              onPressed: () async {
                if (widget.note!.status == "deleted") {
                  await notesController.deleteForever(
                    widget.note!.id,
                  );
                  Get.back();
                  HelperMethods.showSnackbarWithOutActions(
                    'deleteForeverSuccess'.tr,
                  );
                } else {
                  await notesController.moveNote(
                    widget.note!,
                    'deleted',
                  );
                  Get.back();
                  HelperMethods.showSnackbarWithOutActions(
                    'deletedSuccess'.tr,
                  );
                }
              },
            ),
            const SizedBox(width: 8),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'titleHint'.tr,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: contentController,
                  style: const TextStyle(fontSize: 18),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'contentHint'.tr,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: BottomNavigationBar(
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.color_lens_outlined),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: IconButton(
                        onPressed: () => HelperMethods.showNoteOptions(
                          widget.note!,
                        ),
                        icon: const Icon(Icons.more_vert),
                      ),
                      label: "",
                    ),
                  ],
                  onTap: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
