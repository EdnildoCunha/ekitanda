import 'package:ekitanda/model/usuario.dart';
import 'package:ekitanda/widget/card_pedidos.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MinhasVendas extends StatefulWidget {
  @override
  _NewPageMinhasVendas createState() => _NewPageMinhasVendas();
}

class _NewPageMinhasVendas extends State<MinhasVendas> {
  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        ModalRoute.of(context).settings.arguments as Usuario;

    Future<List> getVendas(String token) async {
      List pedidos = [];
      try {
        var response = await Dio().get(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/all/completed',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Todos as vendas',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: getVendas(usuario.token),
              builder: (context, listaPedidos) {
                List<Widget> children = [];
                if (listaPedidos.hasData) {
                  if (listaPedidos.data.length < 1) {
                    children.add(Center(
                      child: Text(
                        "Ainda não há vendas",
                        style: TextStyle(fontSize: 20),
                      ),
                    ));
                  } else {
                    listaPedidos.data.forEach((item) {
                      children.add(CardPedidos(
                        pedido: item,
                        usuario: usuario,
                      ));
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
