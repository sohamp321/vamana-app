import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import "dart:developer" as dev;
import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:vamana_app/dashboard/dashboard_page.dart';
import 'package:vamana_app/login/login_bloc/login_bloc.dart';
import 'package:vamana_app/login/login_bloc/login_event.dart';
import 'package:vamana_app/login/login_bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller for user inputs
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Toggle states
  bool isLoginSelected = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bg2.jpg",
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    "Vamana App",
                    style: TextStyle(
                        color: Color(0xff15400D),
                        fontWeight: FontWeight.w900,
                        fontSize: 50),
                  )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffcfe1b9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Segmented Toggle Button
                        ToggleButtons(
                          borderColor: const Color(0xff15400D),
                          selectedBorderColor: const Color(0xff15400D),
                          selectedColor: Colors.white,
                          fillColor: const Color(0xff0f6f03),
                          isSelected: [isLoginSelected, !isLoginSelected],
                          onPressed: (index) {
                            setState(() {
                              isLoginSelected = index == 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text("Log In"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text("Sign Up"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                                label: Text("User Name"),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your user name';
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                label: Text("Password"),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) {
                              if (state is LoginError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Error Occured: ${state.error}")));
                              } else if (state is UserVerified) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Success")));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            DashBoardPage())));
                              }
                            }, builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is CheckingUser
                                    ? null
                                    : () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          BlocProvider.of<LoginBloc>(context)
                                              .add(CheckUser(
                                                  userName:
                                                      userNameController.text,
                                                  userPwd:
                                                      passwordController.text,
                                                  isLoggingIn:
                                                      isLoginSelected));
                                        }
                                      },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xff0f6f03))),
                                child: state is CheckingUser
                                    ? const CircularProgressIndicator.adaptive(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        isLoginSelected ? "Log In" : "Sign Up",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
