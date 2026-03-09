import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import 'package:notes_app_with_getx/views/screens/note_details.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import '../../models/note_model.dart';
class NotesGridView extends StatelessWidget {
  final List<NoteModel> notes;
  const NotesGridView({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isGrid = Get.find<UIStateController>().isGrid;
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isGrid ? 2 : 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isGrid ? 0.8 : 1.3,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return BuildNoteCard(note: note);
        },
      );
    });
  }
}

class BuildNoteCard extends StatelessWidget {
  final NoteModel note;
  const BuildNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
        Get.to(NoteDetails(note: note, isNewNote: false));
         
        },
        onLongPress: () => HelperMethods.showNoteOptions(note),

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Divider(thickness: 0.5),
              Expanded(
                child: Text(
                  note.content,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ),

              const SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 215, 207, 207),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  note.categoryName != null ? note.categoryName.toString() : '',
                  style: const TextStyle(
                    // backgroundColor: const Color.fromARGB(255, 215, 207, 207),
                    fontSize: 12,
                    color: Color.fromARGB(255, 38, 24, 24),
                  ),
                ),
              ),
              Text(
                "${'lastUpdate'.tr} :${note.lastUpdate!.year}/${note.lastUpdate!.month}/${note.lastUpdate!.day}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
