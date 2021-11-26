import 'package:flutter/material.dart';
import 'package:flutter_auth/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Home page",
          textAlign: TextAlign.center,
        ),
        TextButton(
            onPressed: () async {
              bool left = await signOut();
              if (left) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              }
            },
            child: Text("Sair"))
      ],
    ));
  }

  Future<bool> signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }
}
