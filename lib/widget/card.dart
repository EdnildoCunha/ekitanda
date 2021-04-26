import 'package:dio/dio.dart';
import 'package:ekitanda/model/produto.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';

class CardProduto extends StatelessWidget {
  final Produto produto;
  final Usuario usuario;

  CardProduto({this.produto, this.usuario});

  @override
  Widget build(BuildContext context) {
    Future<void> removerProduto(String token, String id) async {
      try {
        await Dio().delete(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products/$id',
            options: Options(headers: {"Authorization": 'Bearer $token'}));
      } catch (e) {
        print(e);
      }
    }

    Future<void> _showMyDialog(String title, String content) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('$content'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CONFIRMAR',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                onPressed: () async {
                  await removerProduto(usuario.token, '${produto.id}');
                  Navigator.pushNamed(context, '/produtos', arguments: usuario);
                },
              ),
              TextButton(
                child: Text(
                  'CANCELAR',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    List<Widget> childrenRowTop = [Container()];
    List<Widget> childrenRowBottom = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "R\$ ${produto.price},00",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      SizedBox(width: 20),
    ];

    if (usuario.isAdmin == true) {
      childrenRowTop.add(
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextButton(
              onPressed: () async {
                _showMyDialog('Você tem certeza que quer remover este produto?',
                    'Aperte em confirmar para continuar com a remoção');
              },
              child: Text(
                "Remover produto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )),
        ),
      );
    } else {
      childrenRowBottom.add(
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/single_product',
                    arguments: [produto.id, usuario]);
              },
              child: Text(
                "Ver mais",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.black54,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.green[20],
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
         children: [
          Row(
            children: childrenRowTop,
          ),
          ListTile(
            leading: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                child: Image.network(produto.imageUrl, fit: BoxFit.fill,)
              ),
            ),
            title: Text(
              produto.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              produto.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: childrenRowBottom,
          ),
        ]),
      ),
    );
  }
}
