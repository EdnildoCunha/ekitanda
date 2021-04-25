import 'package:flutter/material.dart';

class Usuario{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  final String createdAt;
  final String updatedAt;
  final String token;

  Usuario({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.isAdmin,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.token
  });

  @override
  String toString() {
    return '$firstName $lastName';
  }
}