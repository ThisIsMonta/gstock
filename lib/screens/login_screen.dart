import 'package:flutter/material.dart';
import 'package:gstock/classes/Admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen() : super();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Admin currentAdmin = Admin(username: "admin", password: "admin");

  IconData _iconVisible = Icons.visibility_off;

  final _formKey = GlobalKey<FormState>();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  void _login(Admin admin) {
    if(admin.username == currentAdmin.username && admin.password == currentAdmin.password){
      _formKey.currentState!.reset();
      Navigator.of(context).pushReplacementNamed('/home',
          arguments: Admin(username: "admin", password: "admin"));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Wrong credentials !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Image.asset('images/logo_1.png', height: 60.0),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "GSTOCK",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 60.0,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Text('Login',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary)),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'username is required !';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: (Colors.grey[300])!),
                    ),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'password is required !';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: (Colors.grey[300])!),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                        icon:
                            Icon(_iconVisible, color: Colors.grey[400], size: 20),
                        onPressed: () {
                          _toggleObscureText();
                        }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>
                            Theme.of(context).colorScheme.secondary,
                      ),
                      overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(Admin(username: _usernameController.text, password: _passwordController.text));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
