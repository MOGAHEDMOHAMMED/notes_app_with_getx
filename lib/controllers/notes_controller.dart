// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/auth_controller.dart';

import '../models/note_model.dart';
import '../models/category_model.dart';
import '../core/firestore_service.dart';

class NotesController extends GetxController {
  final FirestoreService _service = FirestoreService();

  final RxList<NoteModel> _notes = <NoteModel>[].obs;
  final Rx<bool> _isLoading = false.obs;
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final Rx<bool> isLoadingCategory = false.obs;

  List<CategoryModel> get categories => _categories;
  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading.value;
  List<NoteModel> get archivedNotes =>
      _notes.where((note) => note.status == 'archived').toList();

  List<NoteModel> get deletedNotes =>
      _notes.where((note) => note.status == 'deleted').toList();

  List<NoteModel> get activeNotes =>
      _notes.where((note) => note.status == 'active').toList();
  Future<void> getNotes(User? user) async {
    if (user == null) {
      _notes.value = [];
      return;
    }
    _notes.bindStream(_service.getNotes(user.uid));
  }

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      getNotes(user);
      if (user != null) {
        _categories.bindStream(_service.getCategories(user.uid));
      } else {
        _categories.clear();
      }
    });
  }

  List<NoteModel> categoryNotes(String categoryName) {
    return _notes
        .where((element) => element.categoryName == categoryName)
        .toList();
  }

  Future<void> addNote(
    String title,
    String content, {
    CategoryModel? category,
    String status = "active",
  }) async {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;

    try {
      _isLoading.value = true;
      final newNote = NoteModel(
        id: '',
        title: title.isEmpty ? "بدون عنوان" : title,
        content: content,
        createdAt: DateTime.now(),
        lastUpdate: DateTime.now(),
        userId: user.uid,
        categoryId: category?.id,
        categoryName: category?.name,
        categoryColor: category?.color,
        status: status,
        color: '',
      );

      await _service.addNote(newNote);
      refresh();
    } finally {
      _isLoading.value = false;
    }
  }

  NoteModel? emptyNote({
    String status = "active",
    CategoryModel? categoryModel,
  }) {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return null;

    return NoteModel(
      id: '',
      title: '',
      content: '',
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
      userId: user.uid,
      categoryId: categoryModel?.id ?? '',
      categoryName: categoryModel?.name ?? '',
      categoryColor: categoryModel?.color ?? 0,
      status: status,
    );
  }

  Future<void> updateNote(
    NoteModel oldNote,
    String newTitle,
    String newContent, {
    CategoryModel? newCategory,
    String? color,
  }) async {
    try {
      _isLoading.value = true;
      final updatedNote = NoteModel(
        id: oldNote.id,
        title: newTitle,
        content: newContent,
        createdAt: oldNote.createdAt,
        lastUpdate: DateTime.now(),
        userId: oldNote.userId,
        categoryId: newCategory?.id ?? oldNote.categoryId,
        categoryName: newCategory?.name ?? oldNote.categoryName,
        categoryColor: newCategory?.color ?? oldNote.categoryColor,
        status: oldNote.status,
        color: color ?? oldNote.color,
      );

      await _service.updateNote(updatedNote);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateCategoryName(
    CategoryModel oldCategory,
    String newName,
  ) async {
    try {
      final user = Get.find<AuthController>().currentUser;
      if (user == null) return;

      isLoadingCategory.value = true;

      final CategoryModel newCategory = CategoryModel(
        id: oldCategory.id,
        name: newName,
        color: oldCategory.color,
      );
      await _service.updateCategory(newCategory, user.uid);
      List<NoteModel> oldCategoryNotes = categoryNotes(oldCategory.name);
      if (oldCategoryNotes.isNotEmpty) {
        for (var note in oldCategoryNotes) {
          await changeNoteCategory(note, newCategory);
        }
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoadingCategory.value = false;
    }
  }

  Future<void> moveNote(NoteModel note, String newStatus) async {
    final updatedNote = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      lastUpdate: DateTime.now(),
      userId: note.userId,
      status: newStatus,
      categoryId: note.categoryId,
      categoryName: note.categoryName,
      categoryColor: note.categoryColor,
    );
    await _service.updateNote(updatedNote);
  }

  Future<void> deleteForever(String noteId) async {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;

    await _service.deleteNote(noteId, user.uid);
  }

  Future<void> addCategory(String catName, String catColor) async {
    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;
    try {
      isLoadingCategory.value = true;
      final newCategory = CategoryModel(
        id: '',
        color: catColor.isEmpty ? 0 : int.parse(catColor),
        name: catName.isEmpty ? "تصنيف بدون اسم" : catName,
      );

      await _service.addCategory(newCategory, user.uid);
    } finally {
      isLoadingCategory.value = false;
    }
  }

  Future<void> changeNoteCategory(
    NoteModel note,
    CategoryModel? newCategory,
  ) async {
    final updatedNote = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      lastUpdate: DateTime.now(),
      userId: note.userId,
      status: note.status,
      categoryId: newCategory?.id,
      categoryName: newCategory?.name,
      categoryColor: newCategory?.color,
    );
    await _service.updateNote(updatedNote);
  }
}
