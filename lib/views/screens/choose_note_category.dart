// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/l10n/app_localizations.dart';
import '../../models/category_model.dart';
import '../../models/note_model.dart';
import '../../controllers/notes_provider.dart';

class SelectCategoryScreen extends StatefulWidget {
  final NoteModel note;
  const SelectCategoryScreen({super.key, required this.note});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  CategoryModel? _selectedCategory;
  bool _isInit = true;
  final notesController = Get.find<NotesController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      try {
        if (widget.note.categoryId != null &&
            widget.note.categoryId!.isNotEmpty) {
          _selectedCategory = notesController.categories.firstWhere(
            (cat) => cat.id == widget.note.categoryId,
          );
        } else {
          _selectedCategory = null;
        }
      } catch (e) {
        _selectedCategory = null;
      }
      _isInit = false;
    }
  }

  void _saveOnExit() {
    notesController.changeNoteCategory(widget.note, _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveOnExit();
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            tr.category,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _selectedCategory == null
                      ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                      : theme.colorScheme.surfaceContainerHighest.withOpacity(
                          0.3,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedCategory == null
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: RadioListTile<CategoryModel?>(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    tr.noCategory,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  secondary: CircleAvatar(
                    backgroundColor: theme.colorScheme.inversePrimary,
                    child: Icon(
                      Icons.format_list_bulleted,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: null,
                  groupValue: _selectedCategory,
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  },
                  activeColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                tr.availableCategories,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 12),
              ...notesController.categories.map((category) {
                final isSelected = _selectedCategory == category;
                final catColor = Color(category.color);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? catColor.withOpacity(0.1)
                          : theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? catColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: RadioListTile<CategoryModel>(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        category.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? catColor
                                : theme.colorScheme.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: catColor,
                          radius: 10,
                        ),
                      ),
                      value: category,
                      groupValue: _selectedCategory,
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      },
                      activeColor: catColor,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
