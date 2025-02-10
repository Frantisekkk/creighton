import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/SignupLogic.dart';
import 'package:flutter_application_1/pages/Login.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpLogic(),
      child: Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: Padding(
          padding: defaultPagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: defaultTextFieldDecoration('First Name'),
              ),
              SizedBox(height: defaultVerticalSpacing),
              TextField(
                controller: lastNameController,
                decoration: defaultTextFieldDecoration('Last Name'),
              ),
              SizedBox(height: defaultVerticalSpacing),
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

              // Use Consumer for Signup logic
              Consumer<SignUpLogic>(
                builder: (context, signUpLogic, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      bool success = await signUpLogic.registerUser(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        context, // Pass context for error handling
                      );
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(onLoginSuccess: () {})),
                        );
                      }
                    },
                    child: Text('Sign Up'),
                  );
                },
              ),

              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to Login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(onLoginSuccess: () {})),
                  );
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
