import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CardProdutoGeral extends StatelessWidget {
  final Map<String, dynamic> produto;
  final String token;

  CardProdutoGeral({@required this.produto, @required this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.green,
        elevation: 2.0,
        color: Colors.green[50],
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            leading: Image.network('${produto['image']}'),
            title: Text(
              produto['title'],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              produto['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('Qtd ${produto['qty']}'),
              SizedBox(width: 40),
              Text(
                "R\$ ${produto['price']},00",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
            ]),
          ),
        ]),
      ),
    );
  }
}
