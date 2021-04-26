import 'package:ekitanda/model/usuario.dart';
import 'package:ekitanda/widget/card_pedidos.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MeusPedidos extends StatefulWidget {
  @override
  _NewPageMeusPedidos createState() => _NewPageMeusPedidos();
}

class _NewPageMeusPedidos extends State<MeusPedidos> {
  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        ModalRoute.of(context).settings.arguments as Usuario;

    Future<List> getPedidos(String token) async {
      List pedidos = [];
      try {
        var response = await Dio().get(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders',
            options: Options(headers: {"Authorization": 'Bearer $token'}));
        var resposta = response.data;

        (resposta["data"] as List).forEach((p) {
          pedidos.add(p);
        });
        return pedidos;
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
                  'Todos os pedidos',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FutureBuilder(
              future: getPedidos(usuario.token),
              builder: (context, listaPedidos) {
                List<Widget> children = [];
                List<Widget> childrenCompleted = [];
                List<Widget> childrenCancelled = [];

                if (listaPedidos.hasData) {
                  if (listaPedidos.data.length < 1) {
                    children.add(Center(
                      child: Text(
                        "Ainda não há pedidos",
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
                  } else {
                    listaPedidos.data.forEach((item) {
                      if (item['status'] == 'pending') {
                        children.add(CardPedidos(
                          pedido: item,
                          usuario: usuario,
                        ));
                      }
                      if (item['status'] == 'completed') {
                        childrenCompleted.add(CardPedidos(
                          pedido: item,
                          usuario: usuario,
                        ));
                      }
                      if (item['status'] == 'cancelled') {
                        childrenCancelled.add(CardPedidos(
                          pedido: item,
                          usuario: usuario,
                        ));
                      }
                    });

                    childrenCompleted.forEach((widget) {
                      children.add(widget);
                    });
                    childrenCancelled.forEach((widget) {
                      children.add(widget);
                    });
                  }
                } else {
                  children.add(Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ));
                }

                return Column(
                  children: children,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
