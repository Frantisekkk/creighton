import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/login_logic.dart';
import 'signup_page.dart';
import '../styles/styles.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess; // Callback for login success

  LoginPage({required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late LoginLogic loginLogic;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginLogic>(
      create: (_) => LoginLogic(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: loginAppBarColor,
        ),
        body: Padding(
          padding: defaultPagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: defaultTextFieldDecoration('Email'),
              ),
              SizedBox(height: defaultVerticalSpacing),
              TextField(
                controller: passwordController,
                decoration: defaultTextFieldDecoration('Password'),
                obscureText: true,
              ),
              SizedBox(height: defaultVerticalSpacing),
              Consumer<LoginLogic>(
                builder: (context, loginLogic, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      bool success = await loginLogic.loginUser(
                        emailController.text,
                        passwordController.text,
                        context,
                      );
                      if (success) {
                        widget.onLoginSuccess();
                      }
                    },
                    child: Text('Login'),
                  );
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Don’t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
