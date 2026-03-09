import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/models/category_model.dart';
import '../../controllers/notes_controller.dart';

class EditCategoriesScreen extends StatelessWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesController = Get.find<NotesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('editCategoriesTitle'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
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
                  'addCategory'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => _showCategoryDialog(),
              );
            }

            final category = notesController.categories[index - 1];

            return ListTile(
              leading: const Icon(Icons.label_outline),
              title: Text(category.name),
              trailing: IconButton(
                onPressed: () {
                  _showCategoryDialog(isNewCat: false, oldCategory: category);
                },
                icon: const Icon(Icons.edit),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCategoryDialog({bool isNewCat = true, CategoryModel? oldCategory}) {
    final notesController = Get.find<NotesController>();

    final controller = isNewCat
        ? TextEditingController()
        : TextEditingController(text: oldCategory?.name);

    Get.dialog(
      AlertDialog(
        title: Text(isNewCat ? 'addCategory'.tr : 'updateCategory'.tr),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'categoryNameHint'.tr),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                if (isNewCat) {
                  notesController.addCategory(controller.text.trim(), '111111');
                } else {
                  notesController.updateCategoryName(
                    oldCategory!,
                    controller.text.trim(),
                  );
                }
                Get.back();
              }
            },
            child: Text(isNewCat ? 'add'.tr : 'confirm'.tr),
          ),
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }
}
