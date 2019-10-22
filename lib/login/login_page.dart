import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:bicheros_frontmobile/home_page.dart';
import 'package:bicheros_frontmobile/login/register_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class loginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => loginPageState();
}

class loginPageState extends State<loginPage> {
  // 192.168.0.X
  // 172.20.10.X
  // 192.168.100.X
  //http:10.0.2.2
  var baseDir = "http://172.20.10.6:8000";
  var token;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      radius: 75.0,
      backgroundColor: Colors.transparent,
      child: Image(image: AssetImage("images/logo.png")),
    );

    final username = TextFormField(
      controller: usernameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nombre de usuario',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          var formData = new FormData.from({
            "username": usernameController.text,
            "password": passwordController.text
          });
          token = null;

          try {
            var response =
            await Dio().post(baseDir + "/auth/login/", data: formData);
            print(response);
            token = response.data["key"];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                      token: token,
                      baseDir: baseDir,
                    )));
          } catch (e) {
            Alert(
                context: context,
                title: "Error",
                desc: "Usuario y/o constraseña incorrectos.")
                .show();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.greenAccent,
        child: Text('Log In', style: TextStyle(color: Colors.black)),
      ),
    );

    final registerLabel = FlatButton(
      child: Text(
        'Registrarse',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => registerPage(
                      baseDir: baseDir,
                    )));
      },
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            username,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            registerLabel
          ],
        ),
      ),
    );
  }
}

