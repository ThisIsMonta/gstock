import 'package:flutter/material.dart';

class Component {
  int? id;
  final String name;
  final int quantity;
  final int categoryId;

  Component({
    this.id,
    required this.name,
    required this.quantity,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "quantity": this.quantity,
      "categoryId": this.categoryId,
    };
  }

  Component copy({int? id, String? name, int? quantity, int? categoryId}) =>
      Component(
          id: id ?? this.id,
          name: name ?? this.name,
          quantity: quantity ?? this.quantity,
          categoryId: categoryId ?? this.categoryId);

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json["id"],
      name: json["name"],
      quantity: json["quantity"],
      categoryId: json["categoryId"],
    );
  }

  @override
  String toString() {
    return 'Component{id: $id, name: $name, quantity: $quantity, categoryId: $categoryId}';
  }
}
