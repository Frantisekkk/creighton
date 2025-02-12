import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/LoginLogic.dart';
import 'package:flutter_application_1/pages/Signup.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess; // Callback for login success

  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers remain in the UI
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You can obtain other app-wide states if needed (like AppState) here
    final appState = Provider.of<AppState>(context, listen: false);

    return ChangeNotifierProvider<LoginLogic>(
      create: (_) => LoginLogic(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: loginAppBarColor,
        ),
        body: Padding(
          padding: defaultPagePadding,
          child: Consumer<LoginLogic>(
            builder: (context, loginLogic, child) {
              return Column(
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
                  ElevatedButton(
                    onPressed: () async {
                      // Pass the text from the controllers to your logic method.
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
              );
            },
          ),
        ),
      ),
    );
  }
}
