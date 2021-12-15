import 'package:flutter/material.dart';

class Category {
  int? id;
  final String name;

  Category({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }

  Category copy({int? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }
}
