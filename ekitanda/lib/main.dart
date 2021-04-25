import 'package:ekitanda/home/home_page_produtos.dart';
import 'package:ekitanda/home/view_cart.dart';
import 'package:ekitanda/widget/single_product_view.dart';
import 'package:flutter/material.dart';
import 'package:ekitanda/home/home_page.dart';
import 'package:ekitanda/auth/login.dart';
import 'package:ekitanda/auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Kitanda',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/produtos': (context) => HomePageProdutos(),
        '/single_product': (context) => SingleProduct(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
*/
