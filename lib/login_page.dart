import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLogin = true;

  bool isLoading = false;

  Future<void> handleAuth() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (isLogin) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text
              .trim(),

          password:
              passwordController.text
                  .trim(),
        );
      } else {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text
              .trim(),

          password:
              passwordController.text
                  .trim(),
        );

        User user =
            FirebaseAuth.instance
                .currentUser!;

        String username =
            emailController.text
                .trim()
                .split("@")[0];

        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(user.uid)
            .set({
          "email":
              emailController.text
                  .trim(),

          "uid": user.uid,

          "username": username,

          "isOnline": true,

          "createdAt":
              DateTime.now(),
        });
      }

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder:
              (context) =>
                  const HomePage(),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Widget buildTextField({
    required String hint,
    required TextEditingController
        controller,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            const Color(
                0xff18181B),

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border: Border.all(
          color: Colors.deepPurple
              .withOpacity(0.35),
        ),
      ),

      child: TextField(
        controller: controller,

        obscureText: obscure,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: hint,

          hintStyle:
              const TextStyle(
            color: Colors.white54,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 22,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          // TOP GLOW
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              width: 260,
              height: 260,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: Colors
                    .deepPurple
                    .withOpacity(0.25),
              ),
            ),
          ),

          // BOTTOM GLOW
          Positioned(
            bottom: -150,
            right: -120,
            child: Container(
              width: 320,
              height: 320,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: Colors
                    .purple
                    .withOpacity(0.2),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                24,
              ),

              child: Column(
                children: [

                  const SizedBox(
                    height: 80,
                  ),

                  // LOGO
                  Container(
                    width: 180,
                    height: 180,

                    decoration:
                        BoxDecoration(
                      gradient:
                          const LinearGradient(
                        colors: [
                          Color(0xff7C3AED),
                          Color(0xffA855F7),
                        ],
                      ),

                      shape:
                          BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .deepPurple
                              .withOpacity(
                            0.7,
                          ),

                          blurRadius:
                              60,

                          spreadRadius:
                              10,
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.mic,

                      color:
                          Colors.white,

                      size: 90,
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  const Text(
                    "Jin Walkie",

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize: 42,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  const Text(
                    "Secure futuristic realtime communication",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color:
                          Colors.white70,

                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // EMAIL
                  buildTextField(
                    hint: "Email",
                    controller:
                        emailController,
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  // PASSWORD
                  buildTextField(
                    hint: "Password",
                    controller:
                        passwordController,

                    obscure: true,
                  ),

                  const SizedBox(
                    height: 35,
                  ),

                  // BUTTON
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : handleAuth,

                    child: Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 22,
                      ),

                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                                0xff7C3AED),

                            Color(
                                0xffA855F7),
                          ],
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .deepPurple
                                .withOpacity(
                              0.5,
                            ),

                            blurRadius:
                                25,
                          ),
                        ],
                      ),

                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color:
                                    Colors.white,
                              )
                            : Text(
                                isLogin
                                    ? "LOGIN"
                                    : "CREATE ACCOUNT",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,

                                  fontSize:
                                      18,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin =
                            !isLogin;
                      });
                    },

                    child: Text(
                      isLogin
                          ? "Create new account"
                          : "Already have account?",

                      style:
                          const TextStyle(
                        color:
                            Colors.white70,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}