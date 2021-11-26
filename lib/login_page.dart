import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formkey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "e-mail"),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please, digite seu e-mail';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(_emailController.text)) {
                    return 'Por favor, preencha um e-mail válido!';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "senha"),
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                validator: (senha) {
                  if (senha == null || senha.isEmpty) {
                    return "Por fvor, digite sua senha";
                  } else if (senha.length < 6) {
                    return "Por favor, digite uma senha maior que 6 caracteres";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formkey.currentState!.validate()) {
                      var isRight = await login();
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (isRight) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } else {
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text("Entrar"))
            ],
          ),
        ),
      ),
    ));
  }

  final snackBar = SnackBar(
    content: Text("E-mail ou senha inválidos", textAlign: TextAlign.center),
    backgroundColor: Colors.redAccent,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('https://minhasapis.com.br/login/');
    var response = await http.post(url, body: {
      'username': _emailController.text,
      'password': _passwordController.text
    });

    if (response.statusCode == 200) {
      await sharedPreferences.setString(
          'token', "${jsonDecode(response.body)['token']}");
      return true;
    } else {
      return false;
    }
  }
}
