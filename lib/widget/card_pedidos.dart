import 'package:dio/dio.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:ekitanda/widget/card_cart.dart';
import 'package:flutter/material.dart';

class CardPedidos extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final Usuario usuario;
  bool successCancel = false;
  bool successPay = false;

  CardPedidos({@required this.pedido, @required this.usuario});

  Future<void> cancelarPedido(int id, token) async {
    try {
      var response = await Dio().post(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/$id/cancel',
          options: Options(headers: {"Authorization": 'Bearer $token'}));
      successCancel = response.data['success'];
    } catch (e) {
      print(e);
    }
  }

  Future<void> pagarPedido(int id, token) async {
    try {
      var response = await Dio().post(
          'https://restful-ecommerce-ufma.herokuapp.com/api/v1/orders/$id/pay',
          options: Options(headers: {"Authorization": 'Bearer $token'}));
      successPay = response.data['success'];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Pedido número: #${pedido['id']}',
            style: TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold)),
      ),
    ));

    pedido['items'].forEach((item) {
      children.add(CardProdutoCart(
        produto: item,
        token: usuario.token,
      ));
    });

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '${pedido['status']}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('R\$${pedido['grandTotal']},00',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
        )
      ],
    ));

    if (pedido['status'] == 'pending') {
      children.add(Row(children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextButton(
            child: Text(
              'Cancelar',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            onPressed: () async {
              await cancelarPedido(pedido['id'], usuario.token);
              if (successCancel) {
                Navigator.pushNamed(context, '/meus_pedidos',
                    arguments: usuario);
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextButton(
            child: Text(
              'Pagar',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            onPressed: () async {
              await pagarPedido(pedido['id'], usuario.token);
              if (successPay) {
                Navigator.pushNamed(context, '/meus_pedidos',
                    arguments: usuario);
              }
            },
          ),
        )
      ]));
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shadowColor: Colors.green,
        elevation: 2.0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
