import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'friends_page.dart';
import 'requests_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'global_radio_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout(
    BuildContext context,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "isOnline": false,
      });
    }

    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/",
      (route) => false,
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withOpacity(
                  0.25,
                ),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(
                  0.2,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [
                  // TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Jin Walkie",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "Realtime Active",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // PROFILE + LOGOUT
                      Row(
                        children: [
                          // PROFILE
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (
                                    context,
                                  ) =>
                                      const ProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                14,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff7C3AED),
                                    Color(0xffA855F7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  22,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(
                                      0.45,
                                    ),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          // LOGOUT
                          GestureDetector(
                            onTap: () async {
                              await logout(
                                context,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                14,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.orange,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  22,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // MENU BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTopButton(
                        title: "Friends",
                        icon: Icons.people,
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) =>
                                  const FriendsPage(),
                            ),
                          );
                        },
                      ),
                      buildTopButton(
                        title: "Requests",
                        icon: Icons.person_add,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) =>
                                  const RequestsPage(),
                            ),
                          );
                        },
                      ),
                      buildTopButton(
                        title: "Search",
                        icon: Icons.search,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) =>
                                  const SearchPage(),
                            ),
                          );
                        },
                      ),
                      buildTopButton(
                        title: "Settings",
                        icon: Icons.settings,
                        color: Colors.red,
                        onTap: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Settings coming soon 🚀",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const Spacer(),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GlobalRadioPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff7C3AED),
                            Color(0xffA855F7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.5),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.radio,
                            color: Colors.white,
                            size: 34,
                          ),
                          SizedBox(width: 14),
                          Text(
                            "GLOBAL RADIO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // MAIN WALKIE CORE
                  Container(
                    width: 310,
                    height: 310,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7C3AED),
                          Color(0xffA855F7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(
                            0.65,
                          ),
                          blurRadius: 70,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 120,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        const Text(
                          "JIN NETWORK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            "Secure futuristic realtime communication network",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // STATUS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff18181B),
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(
                          0.4,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        const Expanded(
                          child: Text(
                            "Encrypted realtime 1-to-1 walkie network active.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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

  Widget buildTopButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff18181B),
          borderRadius: BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: color.withOpacity(
              0.4,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
