import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance
            .currentUser;

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
            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(
                children: [

                  // TOP BAR
                  Row(
                    children: [

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        child: Container(
                          padding:
                              const EdgeInsets
                                  .all(
                            14,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xff18181B,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child:
                              const Icon(
                            Icons
                                .arrow_back,
                            color:
                                Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 20,
                      ),

                      const Text(
                        "Profile",

                        style: TextStyle(
                          color:
                              Colors.white,

                          fontSize: 32,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 60,
                  ),

                  // PROFILE AVATAR
                  Container(
                    width: 190,
                    height: 190,

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
                              50,

                          spreadRadius:
                              8,
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text(
                        user!.email!
                            .substring(
                              0,
                              1,
                            )
                            .toUpperCase(),

                        style:
                            const TextStyle(
                          color:
                              Colors.white,

                          fontSize: 80,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  // USERNAME CARD
                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xff18181B),

                      borderRadius:
                          BorderRadius.circular(
                        28,
                      ),

                      border: Border.all(
                        color: Colors
                            .deepPurple
                            .withOpacity(
                          0.35,
                        ),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          "USERNAME",

                          style: TextStyle(
                            color:
                                Colors.white54,

                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          user.email!
                              .split("@")[0],

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize: 24,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // EMAIL CARD
                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xff18181B),

                      borderRadius:
                          BorderRadius.circular(
                        28,
                      ),

                      border: Border.all(
                        color: Colors
                            .deepPurple
                            .withOpacity(
                          0.35,
                        ),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          "EMAIL",

                          style: TextStyle(
                            color:
                                Colors.white54,

                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          user.email ??
                              "No Email",

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize: 22,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // STATUS CARD
                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                              0xff18181B),

                      borderRadius:
                          BorderRadius.circular(
                        28,
                      ),

                      border: Border.all(
                        color: Colors
                            .green
                            .withOpacity(
                          0.35,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [

                        Container(
                          width: 16,
                          height: 16,

                          decoration:
                              const BoxDecoration(
                            color:
                                Colors.green,

                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        const SizedBox(
                          width: 14,
                        ),

                        const Text(
                          "Realtime Active",

                          style: TextStyle(
                            color:
                                Colors.white,

                            fontSize: 18,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // VERSION
                  const Text(
                    "Jin Walkie v1.0",

                    style: TextStyle(
                      color:
                          Colors.white38,

                      fontSize: 15,
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