import 'package:ekitanda/model/produto.dart';
import 'package:ekitanda/model/usuario.dart';
import 'package:ekitanda/widget/card.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePageProdutos extends StatefulWidget {
  @override
  _NewHomePageProdutos createState() => _NewHomePageProdutos();
}

class _NewHomePageProdutos extends State<HomePageProdutos> {
  Future<List<Produto>> getProdutos(Usuario user) async {
    List<Produto> produtos = [];
    try {
      if (user != null) {
        var response = await Dio().get(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
            options: Options(headers: {"Authorization": 'Bearer $user.token'}));
        var produto = response.data;

        (produto["data"] as List).forEach((p) {
          produtos.add(Produto(
            id: p['id'],
            title: p['title'],
            description: p['description'],
            price: p['price'],
            imageUrl: p['imageUrl'],
            updatedAt: p['updatedAt'],
            createdAt: p['createdAt'],
          ));
        });
      }
      return produtos;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        ModalRoute.of(context).settings.arguments as Usuario;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, condition) {
          return [
            SliverAppBar(
              backgroundColor: Colors.green,
              title: Text('e-Kitanda'),
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart',
                          arguments: usuario.token);
                    },
                  ),
                )
              ],
              pinned: true,
              floating: true,
              snap: false,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                //title: Text('e-Kitanda'),
                background: Image.asset(
                  'assets/image_sliver.png',
                  fit: BoxFit.fill,
                ),
              ),
            )
          ];
        },
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
                future: getProdutos(usuario),
                builder: (context, listaProdutos) {
                  List<Widget> children = [];
                  if (listaProdutos.hasData) {
                    listaProdutos.data.forEach((item) {
                      children.add(CardProduto(
                        produto: item,
                        usuario: usuario,
                      ));
                    });
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
      ),
    );
  }
}
