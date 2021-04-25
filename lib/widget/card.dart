import 'package:ekitanda/model/produto.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';

class CardProduto extends StatelessWidget {
  final Produto produto;
  final Usuario usuario;

  CardProduto({this.produto, this.usuario});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shadowColor: Colors.green,
        elevation: 2.0,
        color: Colors.green[50],
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            leading: Image.network(produto.imageUrl),
            title: Text(
              produto.title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              produto.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              "R\$ ${produto.price} kg",
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/single_product', arguments: [produto.id, usuario.token]);
                },
                child: Text(
                  "Ver mais",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ),
            ),
          ]),
        ]),
      ),
    );
  }
}
