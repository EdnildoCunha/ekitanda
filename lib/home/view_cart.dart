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
    final Usuario usuario =
        ModalRoute.of(context).settings.arguments as Usuario;
    final String token = usuario.token;

    Widget child;

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
                  Navigator.pushNamed(context, '/meus_pedidos',
                      arguments: usuario);
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showMyDialogFail(String title, String content) async {
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
                  Navigator.of(context).pop();
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
              Navigator.pushNamed(context, '/produtos', arguments: usuario);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Todos os produtos',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: getProdutosCart(token),
              builder: (context, listaProdutos) {
                List<Widget> children = [];
                if (listaProdutos.hasData) {
                  if (listaProdutos.data.length < 1) {
                    children.add(Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Ainda n??o h?? itens no carrinho",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ));
                  } else {
                    listaProdutos.data.forEach((item) {
                      children.add(CardProdutoCart(
                        produto: item,
                        usuario: usuario,
                      ));
                    });
                    children.add(Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, bottom: 70),
                        child: Text(
                          'Total: R\$ $total,00',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
                  }
                } else {
                  children.add(Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ));
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: children,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (total > 0) {
            await finalizarCompra(token);
          }
          if (total <= 0) {
            return _showMyDialogFail('O carrinho n??o possui itens!',
                'Adicione itens e tente novamente!');
          }
          if (success == true) {
            return _showMyDialog('Compra finalizada',
                'Acesse o menu de compras para finalizar o pagamento');
          }
          if (success == false) {
            return _showMyDialogFail(
                'Compra n??o finalizada', 'Tente novamente mais tarde!');
          }
        },
        label: Text("Finalizar compra"),
        icon: Icon(
          Icons.attach_money,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
