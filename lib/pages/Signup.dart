import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation/AppWrapper.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/SignupLogic.dart';
import 'package:flutter_application_1/widgets/registerPage/ConsultantPickerDialog.dart';
import 'package:flutter_application_1/widgets/registerPage/DoctorPickerDialog.dart';
import 'package:flutter_application_1/pages/Login.dart';
import 'package:flutter_application_1/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Text controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => SignUpLogic(appState),
      child: Consumer<SignUpLogic>(
        builder: (context, signUpLogic, child) {
          return Scaffold(
            appBar: AppBar(title: Text(localizations.sign_up_title)),
            body: Padding(
              padding: defaultPagePadding,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Name & Last Name
                    TextField(
                      controller: firstNameController,
                      decoration:
                          defaultTextFieldDecoration(localizations.first_name),
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: lastNameController,
                      decoration:
                          defaultTextFieldDecoration(localizations.last_name),
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    // Email & Password
                    TextField(
                      controller: emailController,
                      decoration:
                          defaultTextFieldDecoration(localizations.email),
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: passwordController,
                      decoration:
                          defaultTextFieldDecoration(localizations.password),
                      obscureText: true,
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    // Birth Number & Age
                    TextField(
                      controller: birthNumberController,
                      decoration: defaultTextFieldDecoration(
                          localizations.birth_number),
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: ageController,
                      decoration: defaultTextFieldDecoration(localizations.age),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: phoneController,
                      decoration: defaultTextFieldDecoration(
                          localizations.phone_number),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    // Doctor Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${localizations.doctor_label} ${signUpLogic.isLoadingDoctors ? localizations.loading : signUpLogic.selectedDoctor}",
                        ),
                        ElevatedButton(
                          onPressed: signUpLogic.doctorList.isEmpty
                              ? null
                              : () async {
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (context) => DoctorPickerDialog(
                                      doctors: signUpLogic.doctorList,
                                      initialDoctor: signUpLogic.selectedDoctor,
                                    ),
                                  );
                                  if (result != null) {
                                    signUpLogic.setDoctor(result);
                                  }
                                },
                          child: Text(localizations.select_doctor_button),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    // Consultant Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${localizations.consultant_label} ${signUpLogic.isLoadingConsultants ? localizations.loading : signUpLogic.selectedConsultant}",
                        ),
                        ElevatedButton(
                          onPressed: signUpLogic.consultantList.isEmpty
                              ? null
                              : () async {
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (context) =>
                                        ConsultantPickerDialog(
                                      consultants: signUpLogic.consultantList,
                                      initialConsultant:
                                          signUpLogic.selectedConsultant,
                                    ),
                                  );
                                  if (result != null) {
                                    signUpLogic.setConsultant(result);
                                  }
                                },
                          child: Text(localizations.select_consultant_button),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    ElevatedButton(
                      onPressed: () async {
                        bool success = await signUpLogic.registerUser(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          passwordController.text,
                          birthNumberController.text,
                          ageController.text,
                          phoneController.text,
                          context,
                        );

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppWrapper()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.registration_failed),
                            ),
                          );
                        }
                      },
                      child: Text(localizations.sign_up_button),
                    ),

                    SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        // Navigate to Login page if user already has an account
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              onLoginSuccess: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppWrapper()),
                                );
                              },
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(localizations.already_have_account),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
