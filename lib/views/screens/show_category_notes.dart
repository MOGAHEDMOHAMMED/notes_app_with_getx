import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_app_with_getx/core/app_routes.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import 'package:notes_app_with_getx/views/widget/app_drawer.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';

import 'package:notes_app_with_getx/controllers/notes_controller.dart';
import 'package:notes_app_with_getx/views/widget/center_if_notes_empty.dart';
import 'package:notes_app_with_getx/views/widget/notes_grid_view.dart';

class ShowCategoryNotes extends StatelessWidget {
  final CategoryModel categoryModel;
  const ShowCategoryNotes({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    return Scaffold(
      appBar: AppBar(title: Text(categoryModel.name)),
      drawer: AppDrawer(currentScreen: AppRoutes.showCategoryNotes),

      body: Obx(
        () => notesController.categoryNotes(categoryModel.name).isEmpty
            ? CenterIfNotesEmpty(
                icon: Icons.label_outline,
                message: 'noCategoryNotes'.tr,
              )
            : NotesGridView(
                notes: notesController.categoryNotes(categoryModel.name),
              ),
      ),
      floatingActionButton: HelperMethods.addNoteButton(
        categoryModel: categoryModel,
      ),
    );
  }
}
