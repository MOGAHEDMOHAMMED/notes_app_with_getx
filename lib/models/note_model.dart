class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? lastUpdate;
  final String userId;
  final String color;

  final String? categoryId;
  final String? categoryName;
  final int? categoryColor;

  final String status;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.lastUpdate,
    required this.userId,
    this.categoryId,
    this.categoryName,
    this.categoryColor,
    this.status = "active",
     this.color="",
  });

  factory NoteModel.fromMap(Map<String, dynamic> map, String docId) {
    return NoteModel(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      lastUpdate: map['lastUpdate'] != null
          ? DateTime.tryParse(map['lastUpdate'])
          : null,
      userId: map['userId'] ?? '',
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      categoryColor: map['categoryColor'],
      status: map['status'] ?? "active",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdate': lastUpdate?.toIso8601String(),
      'userId': userId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryColor': categoryColor,
      'status': status,
    };
  }
}
