import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

import 'login_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() =>
      _MyAppState();
}

class _MyAppState
    extends State<MyApp>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addObserver(this);

    updateOnlineStatus(
      true,
    );
  }

  @override
  void dispose() {

    WidgetsBinding.instance
        .removeObserver(this);

    updateOnlineStatus(
      false,
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {

    if (state ==
        AppLifecycleState.resumed) {

      updateOnlineStatus(
        true,
      );
    }

    if (state ==
            AppLifecycleState.paused ||
        state ==
            AppLifecycleState.detached ||
        state ==
            AppLifecycleState.hidden) {

      updateOnlineStatus(
        false,
      );
    }
  }

  Future<void> updateOnlineStatus(
    bool isOnline,
  ) async {

    final user =
        FirebaseAuth
            .instance
            .currentUser;

    if (user == null) return;

    try {

      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(user.uid)
          .set({

        "isOnline":
            isOnline,

        "lastSeen":
            Timestamp.now(),

      }, SetOptions(
        merge: true,
      ));

    } catch (e) {

      debugPrint(
        "Presence Error: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      theme: ThemeData.dark(),

      home: StreamBuilder(
        stream:
            FirebaseAuth.instance
                .authStateChanges(),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Scaffold(
              backgroundColor:
                  Colors.black,

              body: Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Colors.deepPurple,
                ),
              ),
            );
          }

          if (snapshot.hasData) {

            return const HomePage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}