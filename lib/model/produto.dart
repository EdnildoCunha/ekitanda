import 'package:flutter/material.dart';

class Produto {
  final int id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  Produto(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.createdAt,
      @required this.updatedAt});

  Produto.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.title = json['title'],
        this.description = json['description'],
        this.price = json['price'],
        this.imageUrl = json['imageUrl'],
        this.createdAt = json['createdAt'],
        this.updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'updateAt': updatedAt,
      };

  @override
  String toString() {
    return '$title - R\$$price';
  }
}
