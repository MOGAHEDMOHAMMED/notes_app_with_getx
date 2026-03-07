// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/auth_provider.dart';

import '../models/note_model.dart';
import '../models/category_model.dart';
import '../core/services/firestore_service.dart';

class NotesProvider2 extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  List<NoteModel> _notes = [];
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  StreamSubscription? _notesSubscription;
  StreamSubscription? _categorySubscription;
  bool _isLoading = false;
  bool isLoadingCategory = false;

  NotesProvider2() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      listenToNotes();
      listenToCategory();
    });
  }

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;

  List<NoteModel> get archivedNotes =>
      _notes.where((note) => note.status == 'archived').toList();

  List<NoteModel> get deletedNotes =>
      _notes.where((note) => note.status == 'deleted').toList();

  List<NoteModel> get activeNotes =>
      _notes.where((note) => note.status == 'active').toList();

  void listenToNotes() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _notes = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    _notesSubscription?.cancel();

    _notesSubscription = _service.getNotes(user.uid).listen((notesData) {
      _notes = notesData;
      _isLoading = false;
      print(" تم جلب ${_notes.length} ملاحظة من الفايربيس");
      notifyListeners();
    });
  }

  List<NoteModel> categoryNotes(String categoryName) {
    List<NoteModel> catNotes = notes
        .where(
          (element) =>
              (element.categoryName != null &&
              element.categoryName == categoryName),
        )
        .toList();
    return catNotes;
  }

  void listenToCategory() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _categories = [];
      notifyListeners();
      return;
    }

    isLoadingCategory = true;
    notifyListeners();

    _categorySubscription?.cancel();

    _categorySubscription = _service.getCategories(user.uid).listen((
      notesData,
    ) {
      _categories = notesData;
      isLoadingCategory = false;

      print(" تم جلب ${_categories.length} تصنيف من الفايربيس");

      notifyListeners();
    });
  }

  Future<void> addNote(
    String title,
    String content, {
    CategoryModel? category,
    String status = "active",
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

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
  }

  NoteModel? emptyNote({
    String status = "active",
    CategoryModel? categoryModel,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final newNote = NoteModel(
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

    return newNote;
  }

  Future<void> updateNote(
    NoteModel oldNote,
    String newTitle,
    String newContent, {
    CategoryModel? newCategory,
    String? color,
  }) async {
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
  }

  Future<void> updateCategoryName(
    CategoryModel oldCategory,
    String newName,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final CategoryModel newCategory = CategoryModel(
        id: oldCategory.id,
        name: newName,
        color: oldCategory.color,
      );
      _service.updateCategory(newCategory, user.uid);
      List oldCategoryNotes = categoryNotes(oldCategory.name);

      if (oldCategoryNotes.isNotEmpty) {
        for (var note in oldCategoryNotes) {
          await changeNoteCategory(note, newCategory);
        }

        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _service.deleteNote(noteId, user.uid);
  }

  Future<void> addCategory(String catName, String catColor) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newNote = CategoryModel(
      id: '',
      color: catColor.isEmpty ? 0 : int.parse(catColor),
      name: catName.isEmpty ? "تصنيف بدون اسم" : catName,
    );

    await _service.addCategory(newNote, user.uid);
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

  @override
  void dispose() {
    _notesSubscription?.cancel();
    _categorySubscription?.cancel();
    super.dispose();
  }
}

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

  @override
  void onReady() {
    super.onReady();

    final user = Get.find<AuthController>().currentUser;
    if (user == null) return;
    _notes.bindStream(_service.getNotes(user.uid));
    _categories.bindStream(_service.getCategories(user.uid));
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
