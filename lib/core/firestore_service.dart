import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app_with_getx/models/note_model.dart';
import '../models/category_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNote(NoteModel note) async {
    try {
      await _db
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .add(note.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _db
          .collection('users')
          .doc(note.userId)
          .collection('notes')
          .doc(note.id)
          .update(note.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(CategoryModel category,String userId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<NoteModel>> getNotes(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('lastUpdate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> deleteNote(String noteId, String userId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Future<void> addCategory(CategoryModel cat, String userId) async {
    try {
      await _db.collection('users').doc(userId).collection('categories').add({
        'name': cat.name,
        'color': cat.color,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<CategoryModel>> getCategories(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return CategoryModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> deleteCategory(String categoryId, String userId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }
}
