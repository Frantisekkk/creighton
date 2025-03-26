import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_application_1/state/AppState.dart';

class ProfileController extends ChangeNotifier {
  late BuildContext context;
  late String firstName;
  late String lastName;
  late String email;
  late String phone;
  late String consultantName;
  late String doctorName;
  late String profileImageUrl;
  late String birthNumber;

  bool _isLoading = true;

  ProfileController(this.context);

  bool get isLoading => _isLoading;

  Future<void> loadProfileData() async {
    final appState = Provider.of<AppState>(context, listen: false);

    if (appState.userProfile == null) {
      await appState.fetchUserProfile();
    }

    final userProfile = appState.userProfile ?? {};

    firstName = userProfile['first_name'] ?? "N/A";
    lastName = userProfile['last_name'] ?? "N/A";
    email = userProfile['email'] ?? "N/A";
    phone = userProfile['phone'] ?? "N/A";
    consultantName = userProfile['consultant_name'] ?? "N/A";
    doctorName = userProfile['doctor_name'] ?? "N/A";
    profileImageUrl =
        userProfile['profile_image'] ?? "https://via.placeholder.com/150";
    birthNumber = userProfile['birth_number'] ?? "N/A";

    _isLoading = false;
  }

  void showLogoutConfirmationDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.confirm_logout,
          ),
          content: Text(localizations.confirm_text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Provider.of<AppState>(context, listen: false).logout();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(localizations.logout,
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
