import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import '../models/httpexception.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> formkey = GlobalKey();

  Map<String, String> authData = {'email': '', 'password': ''};

  final passwordController = TextEditingController();
  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("An error occured"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Okay"))
              ],
            ));
  }

  var isLoading = false;
  Future<void> submitForm() async {
    if (!formkey.currentState!.validate()) {
      return;
    }

    formkey.currentState!.save();
    setState(() => isLoading = true);
    try {
      if (isLogin) {
        await Provider.of<AuthProvider>(context, listen: false).login(
          (authData['email']).toString(),
          (authData['password']).toString(),
        );
      } else {
        await Provider.of<AuthProvider>(context, listen: false).signUp(
          (authData['email']).toString(),
          (authData['password']).toString(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = ' Could not process';
      if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email does not exists';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Email already exists';
      }
      showErrorDialog(errorMessage);
    }
    setState(() => isLoading = false);
  }

  bool isLogin = true;
  void swithMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.amber),
            child: Center(
              child: Card(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  height: 350,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: formkey,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              Text(isLogin ? "Login" : "Signup"),
                              TextFormField(
                                key: ValueKey('email'),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Enter email is invalid';
                                  }
                                },
                                decoration: InputDecoration(
                                  label: Text("Enter email"),
                                ),
                                onSaved: (value) {
                                  authData['email'] = value!;
                                },
                              ),
                              TextFormField(
                                key: ValueKey('password'),
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Password is too short';
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: Text("Enter password")),
                                onSaved: (value) {
                                  authData['password'] = value!;
                                },
                              ),
                              if (!isLogin)
                                TextFormField(
                                  obscureText: true,
                                  validator: (value) {
                                    if (value != passwordController.text) {
                                      return 'Password does not match';
                                    }
                                  },
                                  decoration: InputDecoration(
                                      label: Text("Enter password again")),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Processing...    "),
                                        CircularProgressIndicator()
                                      ],
                                    )
                                  : TextButton(
                                      onPressed: submitForm,
                                      child: Text(isLogin ? "Login" : "Signup"),
                                    ),
                              TextButton(
                                  onPressed: swithMode,
                                  child: Text(
                                      '${isLogin ? 'SignUp' : 'Login'} Instead'))
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
