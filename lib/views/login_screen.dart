import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:naviindus/services/api_service.dart';
import 'package:naviindus/utils/dynamic_sizing.dart';
import 'package:naviindus/utils/snackbar.dart';
import 'package:naviindus/views/home_screen.dart';
import 'package:naviindus/widgets/button.dart';
import 'package:naviindus/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: R.maxHeight(context),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/loginbg.png",
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  "assets/logo.png",
                  height: R.rh(80, context),
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: R.rw(16, context), vertical: R.rh(24, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login Or Register To Book Your Appointments",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: R.rw(24, context)),
                    ),
                    SizedBox(
                      height: R.rh(20, context),
                    ),
                    TextfieldWidget(
                        textcontroller: usernameController,
                        headText: "Email",
                        hinttext: "Enter your email"),
                    TextfieldWidget(
                        headText: "Password",
                        hinttext: "Enter password",
                        textcontroller: passwordController),
                    const Spacer(),
                    ButtonWidget(
                      text: "Login",
                      onpressed: () {
                        if (usernameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          apiService
                              .loginApi(usernameController.text,
                                  passwordController.text)
                              .then((value) {
                            log(value!.status.toString());
                            if (value.token != null) {
                              ApiService.token = value.token.toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                            } else {
                              snackbar("Invalid Credentials", context);
                            }
                          });
                        } else {
                          snackbar("Please fill all fields ", context);
                        }
                      },
                    ),
                    const Spacer(),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'By creating or logging into an account you are agreeing with our ',
                        style: TextStyle(
                            fontSize: R.rw(13, context),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0028FC))),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: "Privacy Policy.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0028FC)))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
