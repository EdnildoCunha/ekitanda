import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AdicionarProduto extends StatefulWidget {
  @override
  _NewProduto createState() => _NewProduto();
}

class _NewProduto extends State<AdicionarProduto> {
  final inputTitle = TextEditingController();
  final inputDescription = TextEditingController();
  final inputPrice = TextEditingController();
  final inputImageUrl = TextEditingController();

  bool successRegisterNewProduct = false;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Usuario usuario =
        ModalRoute.of(context).settings.arguments as Usuario;

    Future<void> postNewProduct(String title, String description, int price,
        String imageUrl, String token) async {
      try {
        var response = await Dio().post(
            'https://restful-ecommerce-ufma.herokuapp.com/api/v1/products',
            data: {
              'title': title,
              'description': description,
              'price': price,
              'imageUrl': imageUrl
            },
            options: Options(headers: {"Authorization": 'Bearer $token'}));
        successRegisterNewProduct = response.data['success'];
      } catch (e) {
        print(e);
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
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 8.0, left: 8.0, right: 8.0),
                    child: TextFormField(
                      controller: inputTitle,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          hintText: "Título"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 2)
                          return "O campo precisa de pelo menos 5 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: inputDescription,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.comment_rounded,
                            color: Colors.green,
                          ),
                          hintText: "Descrição"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 2)
                          return "O campo precisa de pelo menos 10 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: inputPrice,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            color: Colors.green,
                          ),
                          hintText: "Preço"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: inputImageUrl,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.link_rounded,
                            color: Colors.green,
                          ),
                          hintText: "URL da imagem"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                      },
                    ),
                  ),
                ], //child
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  )),
              width: 220.0,
              height: 45.0,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  child: Text(
                    "CADASTRAR NOVO PRODUTO",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await postNewProduct(
                          inputTitle.text,
                          inputDescription.text,
                          int.parse(inputPrice.text),
                          inputImageUrl.text,
                          usuario.token);

                      if (successRegisterNewProduct) {
                        Navigator.pushNamed(context, '/produtos',
                            arguments: usuario);
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
