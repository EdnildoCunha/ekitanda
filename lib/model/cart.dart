import 'package:ekitanda/model/produto.dart';
import 'package:flutter/material.dart';

class Cart {
  final List<Produto> listaProdutos;

  Cart({
    @required this.listaProdutos
  });

  @override
  String toString(){
    String allProdutos = '';
    listaProdutos.forEach((element) {
      allProdutos += element.title + '\n';
    });

    return allProdutos;

  }
}