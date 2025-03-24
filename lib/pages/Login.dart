import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controllers/LoginLogic.dart';
import 'package:flutter_application_1/navigation/AppWrapper.dart';
import 'package:flutter_application_1/pages/Signup.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
    return ChangeNotifierProvider<LoginLogic>(
      create: (_) => LoginLogic(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.login),
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
                    decoration: defaultTextFieldDecoration(localizations.email),
                  ),
                  SizedBox(height: defaultVerticalSpacing),
                  TextField(
                    controller: passwordController,
                    decoration:
                        defaultTextFieldDecoration(localizations.password),
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
                        Provider.of<AppState>(context, listen: false)
                            .isAuthenticated = true;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => AppWrapper()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: Text(localizations.login),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(localizations.no_account),
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
