import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import '../../core/l10n/app_localizations.dart';
import '../../controllers/notes_provider.dart';

class EditCategoriesScreen extends StatelessWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    final tr = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.editCategoriesTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: notesController.categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text(
                  tr.addCategory,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => _showCategoryDialog(context),
              );
            }

            final category = notesController.categories[index - 1];

            return ListTile(
              leading: const Icon(Icons.label_outline),
              title: Text(category.name),
              trailing: IconButton(
                onPressed: () {
                  _showCategoryDialog(
                    context,
                    isNewCat: false,
                    oldCategory: category,
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context, {
    bool isNewCat = true,
    CategoryModel? oldCategory,
  }) {
    final tr = AppLocalizations.of(context)!;
    final notesController = Get.find<NotesController>();

    final controller = isNewCat
        ? TextEditingController()
        : TextEditingController(text: oldCategory?.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isNewCat ? tr.addCategory : tr.updateCategory),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: tr.categoryNameHint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (isNewCat) {
                  notesController.addCategory(
                    controller.text.trim(),
                    '111111',
                  );
                } else {
                  notesController.updateCategoryName(
                    oldCategory!,
                    controller.text.trim(),
                  );
                }
                Navigator.pop(ctx);
              }
            },
            child: Text(isNewCat ? tr.add : tr.confirm),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.cancel),
          ),
        ],
      ),
    );
  }
}
