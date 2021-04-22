import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_ekitanda.png'),
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  )),
              width: 200.0,
              height: 35.0,
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
            Container(
              decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.0),
                  )),
              width: 200.0,
              height: 35.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton(
                  child: Text(
                    "CADASTRE-SE",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
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
