import 'package:ekitanda/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Register extends StatefulWidget {
  @override
  _NewRegister createState() => _NewRegister();
}

class _NewRegister extends State<Register> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final inputFirstName = TextEditingController();
  final inputLastName = TextEditingController();
  final inputEmail = TextEditingController();
  final inputConfirmPassword = TextEditingController();
  final inputPassword = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool sucessRegister = false;
  Usuario usuario;

  Future<void> postRegister(
      String firstName, lastName, password, email, passwordConfirmation) async {
    try {
      var response = await Dio()
          .post('https://restful-ecommerce-ufma.herokuapp.com/register', data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation
      });
      if (response.data['success']) {
        sucessRegister = true;
        usuario = Usuario(
            id: response.data['data']['id'],
            firstName: response.data['data']['firstName'],
            lastName: response.data['data']['lastName'],
            email: response.data['data']['email'],
            isAdmin: response.data['data']['isAdmin'],
            createdAt: response.data['data']['createdAt'],
            updatedAt: response.data['data']['updatedAt'],
            token: response.data['data']['token']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Cadastre-se"),
        leading: Padding(
          padding: EdgeInsets.all(4.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/');
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
                      controller: inputFirstName,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                          hintText: "Nome"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 2)
                          return "O campo precisa de pelo menos 2 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: inputLastName,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                          hintText: "Sobrenome"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 2)
                          return "O campo precisa de pelo menos 2 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: inputEmail,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.green,
                          ),
                          hintText: "E-mail"),
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 10)
                          return "O campo precisa de pelo menos 10 caracteres";
                        if (!text.contains("@"))
                          return "Este e-mail não é válido";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.green),
                      controller: inputPassword,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          suffixIcon: GestureDetector(
                            child: Icon(
                                _showPassword == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.green),
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                          hintText: "Senha"),
                      obscureText: _showPassword == false ? true : false,
                      validator: (text) {
                        if (text.isEmpty) return "O campo é obrigatório";
                        if (text.length < 6)
                          return "A senha precisa de pelo menos 6 caracteres";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.green),
                      controller: inputConfirmPassword,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          suffixIcon: GestureDetector(
                            child: Icon(
                                _showConfirmPassword == false
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.green),
                            onTap: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                          hintText: "Confirme a senha"),
                      obscureText: _showConfirmPassword == false ? true : false,
                      validator: (text) {
                        if (text.isEmpty ||
                            inputPassword.text != inputConfirmPassword.text)
                          return "As senhas não são iguais";
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
                    "CADASTRE-SE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await postRegister(
                          inputFirstName.text,
                          inputLastName.text,
                          inputPassword.text,
                          inputEmail.text,
                          inputConfirmPassword.text);
                      if (sucessRegister) {
                        Navigator.pushNamed(context, '/produtos',
                            arguments: usuario);
                      }
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black45,
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
                      "LOGIN",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
