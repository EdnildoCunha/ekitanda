import 'package:dio/dio.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';

class CardProdutoCart extends StatelessWidget {
  final Map<String, dynamic> produto;
  final Usuario usuario;

  CardProdutoCart({@required this.produto, @required this.usuario});

  @override
  Widget build(BuildContext context) {
    Future<void> deleteProduct(int id, String token) async {
      var response = await Dio().post(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart/remove/$id',
          options: Options(headers: {"Authorization": 'Bearer $token'}));
      Navigator.pushNamed(context, '/cart', arguments: usuario);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await deleteProduct(produto['id'], usuario.token);
                  },
                ),
              ),
              Text('Qtd ${produto['qty']}'),
              SizedBox(width: 20),
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
