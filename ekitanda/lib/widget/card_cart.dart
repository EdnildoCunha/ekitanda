import 'package:flutter/material.dart';

class CardProdutoCart extends StatelessWidget {
  final Map<String, dynamic> produto;
  final String token;

  CardProdutoCart({this.produto, this.token});

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
            //leading: Image.network(produto['imageUrl']),
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('Qtd ${produto['qty']}'),
            SizedBox(width: 40),
            Text(
              "R\$ ${produto['price']} kg",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                  onPressed: () {
                    print('removido');
                  },
                  child: Text(
                    "Remover",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ]),
        ]),
      ),
    );
  }
}
