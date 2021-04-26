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

    Widget childFloatingButton = Container();
    List<Widget> actions = [];
    List<Widget> childrenListview = [
      UserAccountsDrawerHeader(
        accountName: Text('${usuario.firstName} ${usuario.lastName}',
            style: TextStyle(fontSize: 25)),
        accountEmail: Text('${usuario.email}'),
        decoration: BoxDecoration(
          color: Colors.green,
        ),
      ),
    ];

    if (usuario.isAdmin == true) {
      childrenListview.add(ListTile(
        leading: Icon(Icons.receipt),
        title: Text('Minhas vendas', style: TextStyle()),
        onTap: () {
          Navigator.pushNamed(context, '/minhas_vendas', arguments: usuario);
        },
      ));

      childFloatingButton = FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_produto', arguments: usuario);
        },
        label: Text("Adicionar produto"),
        icon: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.green,
      );
    } else {
      childrenListview.add(ListTile(
        leading: Icon(Icons.receipt),
        title: Text('Meus pedidos', style: TextStyle()),
        onTap: () {
          Navigator.pushNamed(context, '/meus_pedidos', arguments: usuario);
        },
      ));

      actions.add(Padding(
        padding: EdgeInsets.all(4.0),
        child: IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart', arguments: usuario);
          },
        ),
      ));
    }

    childrenListview.add(
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Sair da conta"),
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
      ),
    );

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: childrenListview,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, condition) {
          return [
            SliverAppBar(
              backgroundColor: Colors.green,
              title: Text('e-Kitanda'),
              actions: actions,
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
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Todos os produtos',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
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
                    children.add(Center(
                      child: CircularProgressIndicator(),
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
      ),
      floatingActionButton: Container(
        child: childFloatingButton,
      ),
    );
  }
}
