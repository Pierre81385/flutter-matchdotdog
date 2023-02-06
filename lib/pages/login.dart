import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchdotdog/pages/register.dart';
import '../models/fire_auth.dart';
import '../models/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordTextController,
                      focusNode: _focusPassword,
                      obscureText: true,
                      validator: (value) => Validator.validatePassword(
                        password: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    _isProcessing
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    _focusEmail.unfocus();
                                    _focusPassword.unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      User? user = await FireAuth
                                          .signInUsingEmailPassword(
                                        email: _emailTextController.text,
                                        password: _passwordTextController.text,
                                      );

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      if (user != null) {
                                        print(
                                            "User is successfully logged in!");
                                        // Navigator.of(context).pushReplacement(
                                        //   MaterialPageRoute(
                                        //     builder: (context) => ProfilePage(
                                        //       user: user,
                                        //     ),
                                        //   ),
                                        // );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Sign In',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24.0),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterUser(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Register',
                                  ),
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
