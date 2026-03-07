class CategoryModel {
  final String id;
  final String name;
  final int color; 
  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    return CategoryModel(
      id: docId,
      name: map['name'] ?? '',
      color: map['color'] ?? 0xFF9E9E9E, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color,
    };
  }
}