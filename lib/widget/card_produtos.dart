import 'package:flutter/material.dart';

class CardProdutoGeral extends StatelessWidget {
  final Map<String, dynamic> produto;
  final String token;

  CardProdutoGeral({@required this.produto, @required this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Card(
        shadowColor: Colors.green,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green[50],
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ListTile(
            leading: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10)),
                    child: Image.network(
                      '${produto['image']}',
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            title: Text(
              produto['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
