// models/category.dart
class Category {
  final String name;
  final List<Category>? children;
  final List<Service>? services;

  Category({required this.name, this.children, this.services});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? 'Unknown',
      children: json['children'] != null
          ? (json['children'] as List).map((i) => Category.fromJson(i)).toList()
          : null,
      services: json['services'] != null
          ? (json['services'] as List).map((i) => Service.fromJson(i)).toList()
          : null,
    );
  }
}

// models/service.dart
class Service {
  final String title;
  final String description;

  Service({required this.title, required this.description});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
    );
  }
}
