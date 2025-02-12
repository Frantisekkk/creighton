import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/controllers/SignupLogic.dart';
import 'package:flutter_application_1/widgets/registerPage/ConsultantPickerDialog.dart';
import 'package:flutter_application_1/widgets/registerPage/DoctorPickerDialog.dart';
import 'package:flutter_application_1/pages/Login.dart';
import 'package:flutter_application_1/styles/styles.dart';

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
    return ChangeNotifierProvider(
      create: (_) => SignUpLogic(),
      child: Consumer<SignUpLogic>(
        builder: (context, signUpLogic, child) {
          return Scaffold(
            appBar: AppBar(title: Text("Sign Up")),
            body: Padding(
              padding: defaultPagePadding,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First Name & Last Name
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
                    // Email & Password
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
                    // Birth Number & Age
                    TextField(
                      controller: birthNumberController,
                      decoration: defaultTextFieldDecoration('Birth Number'),
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: ageController,
                      decoration: defaultTextFieldDecoration('Age'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: defaultVerticalSpacing),
                    TextField(
                      controller: phoneController,
                      decoration: defaultTextFieldDecoration('Phone Number'),
                      keyboardType:
                          TextInputType.phone, // ✅ Ensure numeric input
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    // Doctor Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Doctor: ${signUpLogic.isLoadingDoctors ? 'Loading...' : signUpLogic.selectedDoctor}"),
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
                          child: Text("Select Doctor"),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    // Consultant Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Consultant: ${signUpLogic.isLoadingConsultants ? 'Loading...' : signUpLogic.selectedConsultant}"),
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
                          child: Text("Select Consultant"),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultVerticalSpacing),

                    // Sign Up Button
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
                              builder: (context) =>
                                  LoginPage(onLoginSuccess: () {}),
                            ),
                          );
                        }
                      },
                      child: Text('Sign Up'),
                    ),

                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(onLoginSuccess: () {}),
                          ),
                        );
                      },
                      child: Text("Already have an account? Login"),
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
