import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_application_1/state/AppState.dart';

class LoginLogic extends ChangeNotifier {
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.empty_credidentals)),
      );
      return false;
    }

    // Retrieve AppState from the Provider
    final appState = Provider.of<AppState>(context, listen: false);

    try {
      // Call AppState's login method
      final bool isAuthenticated = await appState.login(email, password);
      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.invalid_credidentals)),
        );
      }
      return isAuthenticated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
      return false;
    }
  }
}
