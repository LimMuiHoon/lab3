import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_barter/forgotpasswpordscreen.dart.dart';
import 'package:my_barter/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:my_barter/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:my_barter/newpass.dart';

//https://tradebarterflutter.com/mytradebarter(user)%20/php/login_user.php
String urlLogin =
    "https://tradebarterflutter.com/mytradebarter(user)%20/php/login_user.php";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: new ThemeData(
          backgroundColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFEFEFEF),
          primarySwatch: Colors.red),
      home: new LoginPage(),
    );
  }
}

bool _isChecked = true;
final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _pssscontroller = TextEditingController();
String _password = "";

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: new Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),
                TextField(
                    controller: _emcontroller,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email),
                    )),
                TextField(
                  controller: _pssscontroller,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool value) {
                        _onChange(value);
                      },
                    ),
                    Text('Remember Me', style: TextStyle(fontSize: 17))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 300,
                  height: 50,
                  child: Text('Login'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 20,
                  onPressed: _onLogin,
                ),
                SizedBox(
                  height: 29,
                ),
                GestureDetector(
                    onTap: _onRegister,
                    child: Text('Register New Account',
                        style: TextStyle(fontSize: 16))),
                //Text("Register new account"),
                SizedBox(
                  height: 29,
                ),
                GestureDetector(
                    onTap: _onForgot,
                    child: Text('Forgot Password',
                        style: TextStyle(fontSize: 16))),
                //Text('Forgot password')
              ],
            ),
          ),
        ));
  }

  void _onLogin() {
    _email = _emcontroller.text;
    _password = _pssscontroller.text;
    if (_checkEmail(_email) && (_password.length > 4)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login in");
      pr.show();
      http.post(urlLogin, body: {
        "EMAIL": _email,
        "PASSWORD": _password,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "success") {
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(email: _email)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      print('Check value $value');
      _savePref(value);
    });
  }

  bool _checkEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }

  void _savePref(bool value) async {
    print('Inside savepref');
    //SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pssscontroller.text;
    if (value) {
      //Store value in pref
      if (_checkEmail(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Pref Stored');
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('email invalid!!!');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      //Remove value from pref
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _pssscontroller.text = '';
        _isChecked = false;
      });

      print('pref removed');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _pssscontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      setState(() {
        _isChecked = false;
      });
    }
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }
}
