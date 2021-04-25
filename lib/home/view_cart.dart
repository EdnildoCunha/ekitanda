import 'package:dio/dio.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:ekitanda/widget/card_cart.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _NewCartPage createState() => _NewCartPage();
}

class _NewCartPage extends State<CartPage> {
  int total = 0;
  bool success = false;

  Future<void> finalizarCompra(String token) async {
    var response = await Dio().post(
        'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders',
        options: Options(headers: {"Authorization": 'Bearer $token'}));

    if (response.data['success'] == true) {
      success = true;
    } else {
      success = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario = ModalRoute.of(context).settings.arguments as Usuario;
    final String token = usuario.token;

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
                'OK',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/meus_pedidos', arguments: usuario);
              },
            ),
          ],
        );
      },
    );
  }

    Future<List> getProdutosCart(String token) async {
      List produtos = [];
      try {
        var response = await Dio().get(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart',
            options: Options(headers: {"Authorization": 'Bearer $token'}));
        var produto = response.data;

        total = produto["data"]['cartItem']['totalAmount'];

        print('${produto["data"]['cartItem']['totalAmount']}');

        (produto["data"]['cartItem']['items'] as List).forEach((p) {
          produtos.add(p);
        });
        return produtos;
      } catch (e) {
        return e;
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: Padding(
            padding: EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Todos os produtos',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getProdutosCart(token),
                builder: (context, listaProdutos) {
                  List<Widget> children = [];
                  if (listaProdutos.hasData) {
                    if (listaProdutos.data.length < 1) {
                      children.add(Center(
                        child: Text(
                          "Ainda não há itens no carrinho",
                          style: TextStyle(fontSize: 20),
                        ),
                      ));
                    } else {
                      listaProdutos.data.forEach((item) {
                        children.add(CardProdutoCart(
                          produto: item,
                          token: token,
                        ));
                      });
                    }
                    children.add(Container(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Total: R\$ $total,00',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
                  } else {
                    children.add(Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ));
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await finalizarCompra(token);
            if (success) {
              print('sucesso');
              return _showMyDialog('Compra finalizada',
                  'Acesse o menu de compras para finalizar o pagamento');
            } else {
              print('falha');
              return _showMyDialog(
                  'Compra não finalizada', 'Tente novamente mais tarde!');
            }
          },
          label: Text("Finalizar compra"),
          icon: Icon(
            Icons.attach_money,
          ),
          backgroundColor: Colors.green,
        ));
  }
}
