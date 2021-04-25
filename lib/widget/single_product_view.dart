import 'package:ekitanda/model/produto.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SingleProduct extends StatefulWidget {
  @override
  _SingleProductPage createState() => _SingleProductPage();
}

class _SingleProductPage extends State<SingleProduct> {
  String dropdownValue = '1';
  bool success;

  void addToCart(int id_produto, int qtd_produto, String token) async {
    try {
      var response = await Dio().post(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/cart/add',
          data: {'productId': id_produto, 'qty': qtd_produto},
          options: Options(headers: {"Authorization": 'Bearer $token'}));

      success = response.data['success'];
    } catch (e) {
      print(e);
    }
  }

  Future<Produto> getProduto(int id, String token) async {
    try {
      var response = await Dio().get(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products/$id',
          options: Options(headers: {"Authorization": 'Bearer $token'}));

      if (response.data['success'] == true) {
        Produto produto = Produto(
            id: response.data['data']['id'],
            title: response.data['data']['title'],
            description: response.data['data']['description'],
            price: response.data['data']['price'],
            imageUrl: response.data['data']['imageUrl'],
            createdAt: response.data['data']['createdAt'],
            updatedAt: response.data['data']['updatedAt']);

        return produto;
      }
    } catch (e) {
      return e;
    }
  }

  Future<void> _showMyDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
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

  @override
  Widget build(BuildContext context) {
    final List dados = ModalRoute.of(context).settings.arguments as List;

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
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart', arguments: dados[1]);
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: getProduto(dados[0], dados[1]),
          builder: (context, produto) {
            Widget child;
            if (produto.hasData) {
              child = Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          '${produto.data.imageUrl}',
                          height: 300,
                        ),
                      )),
                      Container(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              '${produto.data.title}',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(
                                '${produto.data.description}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "R\$ ${produto.data.price},00 kg",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 15),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'qtd',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 20),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  style: const TextStyle(color: Colors.green),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.green,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                    '5',
                                    '6',
                                    '7',
                                    '8',
                                    '9',
                                    '10'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      await addToCart(produto.data.id,
                                          int.parse(dropdownValue), dados[1]);
                                      if (success == true) {
                                        print('sucesso');
                                        return _showMyDialog(
                                            '$dropdownValue ${produto.data.title} adicionado(s) ao carrinho com sucesso!');
                                      } else {
                                        print('erro');
                                        return _showMyDialog(
                                            '$dropdownValue ${produto.data.title} adicionado(s) ao carrinho com sucesso!');
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      )),
                    ]),
                  ),
                ),
              );
            } else {
              child = Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              child: child,
            );
          },
        ));
  }
}
