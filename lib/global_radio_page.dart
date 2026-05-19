import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'zego_service.dart';

class GlobalRadioPage extends StatefulWidget {
const GlobalRadioPage({super.key});

@override
State<GlobalRadioPage> createState() =>
_GlobalRadioPageState();
}

class _GlobalRadioPageState
extends State<GlobalRadioPage>
with SingleTickerProviderStateMixin {

bool isTalking = false;

bool isConnected = false;

bool roomFull = false;

bool hasLeftRoom = false;

int usersCount = 0;

late AnimationController pulseController;

final String roomID =
"jin_global_radio";

@override
void initState() {
super.initState();

pulseController =
    AnimationController(
  vsync: this,
  duration: const Duration(
    milliseconds: 900,
  ),
)..repeat(reverse: true);

joinGlobalRadio();

}

Future<void> joinGlobalRadio() async {

final roomRef =
    FirebaseFirestore.instance
        .collection("globalRadio")
        .doc("main");

final snapshot =
    await roomRef.get();

if (!snapshot.exists) {

  await roomRef.set({
    "usersCount": 0,
  });
}

final data =
    (await roomRef.get()).data();

usersCount =
    data?["usersCount"] ?? 0;

if (usersCount >= 5) {

  setState(() {
    roomFull = true;
  });

  return;
}

// INCREASE USER COUNT
await roomRef.update({
  "usersCount":
      FieldValue.increment(1),
});

usersCount++;

final user =
    FirebaseAuth.instance
        .currentUser;

if (user == null) return;

ZegoService.instance
    .onConnectionState =
    (connected) {

  if (mounted) {

    setState(() {
      isConnected =
          connected;
    });
  }
};

await ZegoService.instance
    .loginRoom(
  roomID: roomID,
  userID: user.uid,
  userName:
      user.email ?? "User",
);

}

Future<void> leaveGlobalRadio() async {

// PREVENT MULTIPLE LEAVES
if (hasLeftRoom) return;

hasLeftRoom = true;

final roomRef =
    FirebaseFirestore.instance
        .collection("globalRadio")
        .doc("main");

try {

  final snapshot =
      await roomRef.get();

  final data =
      snapshot.data();

  int currentCount =
      data?["usersCount"] ?? 0;

  // PREVENT NEGATIVE VALUES
  if (currentCount > 0) {

    await roomRef.update({
      "usersCount":
          FieldValue.increment(-1),
    });
  }

} catch (e) {

  debugPrint(
    "Leave Error: $e",
  );
}

// LEAVE ZEGO ROOM
await ZegoService.instance
    .leaveRoom();

}

@override
void dispose() {

leaveGlobalRadio();

pulseController.dispose();

super.dispose();

}

void startTalking() async {

if (!isConnected) return;

setState(() {
  isTalking = true;
});

await ZegoService.instance
    .startTalking();

}

void stopTalking() async {

await ZegoService.instance
    .stopTalking();

setState(() {
  isTalking = false;
});

}

@override
Widget build(BuildContext context) {

return Scaffold(
  backgroundColor:
      Colors.black,

  body: SafeArea(
    child: Padding(
      padding:
          const EdgeInsets.all(
        20,
      ),

      child: Column(
        children: [

          // TOP BAR
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(
                    "GLOBAL RADIO",

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize: 32,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "$usersCount / 5 Connected",

                    style: TextStyle(
                      color: roomFull
                          ? Colors.red
                          : Colors.green,

                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // CLOSE BUTTON
              GestureDetector(
                onTap: () async {

                  await leaveGlobalRadio();

                  if (mounted) {

                    Navigator.pop(
                      context,
                    );
                  }
                },

                child: Container(
                  padding:
                      const EdgeInsets
                          .all(14),

                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                      ],
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child:
                      const Icon(
                    Icons.close,

                    color:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // ROOM FULL
          if (roomFull)

            const Text(
              "GLOBAL RADIO FULL",

              style: TextStyle(
                color:
                    Colors.red,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            )

          else

            AnimatedBuilder(
              animation:
                  pulseController,

              builder:
                  (
                  context,
                  child,
                  ) {

                return Transform.scale(

                  scale: isTalking
                      ? 1 +
                          (pulseController.value *
                              0.08)
                      : 1,

                  child:
                      GestureDetector(

                    onLongPressStart: (_) {

                      // REQUIRE MINIMUM 2 USERS
                      if (usersCount < 2) {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(

                          const SnackBar(

                            backgroundColor:
                                Colors.red,

                            content: Text(
                              "Need at least 2 users in GLOBAL RADIO",
                            ),
                          ),
                        );

                        return;
                      }

                      startTalking();
                    },

                    onLongPressEnd: (_) {

                      stopTalking();
                    },

                    child:
                        AnimatedContainer(

                      duration:
                          const Duration(
                        milliseconds:
                            250,
                      ),

                      width:
                          isTalking
                              ? 340
                              : 300,

                      height:
                          isTalking
                              ? 340
                              : 300,

                      decoration:
                          BoxDecoration(

                        gradient:
                            LinearGradient(

                          begin:
                              Alignment.topLeft,

                          end:
                              Alignment.bottomRight,

                          colors:
                              usersCount < 2

                                  ? [
                                      Colors.grey.shade700,
                                      Colors.black54,
                                    ]

                                  : isTalking

                                      ? [
                                          Colors.red,
                                          Colors.orange,
                                        ]

                                      : [
                                          const Color(
                                              0xff7C3AED),

                                          const Color(
                                              0xffA855F7),
                                        ],
                        ),

                        shape:
                            BoxShape.circle,

                        border:
                            Border.all(

                          color:
                              usersCount < 2
                                  ? Colors.grey
                                  : Colors.white24,

                          width: 4,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                usersCount < 2

                                    ? Colors.grey.withOpacity(
                                        0.4,
                                      )

                                    : isTalking

                                        ? Colors.red.withOpacity(
                                            0.8,
                                          )

                                        : Colors.deepPurple.withOpacity(
                                            0.8,
                                          ),

                            blurRadius:
                                90,

                            spreadRadius:
                                18,
                          ),
                        ],
                      ),

                      child:
                          Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [

                          Icon(

                            usersCount < 2

                                ? Icons.lock

                                : isTalking

                                    ? Icons.mic

                                    : Icons.graphic_eq,

                            color:
                                Colors.white,

                            size: 120,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(

                            usersCount < 2

                                ? "WAITING"

                                : isTalking

                                    ? "TRANSMITTING"

                                    : "HOLD TO TALK",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontSize:
                                  30,

                              fontWeight:
                                  FontWeight.bold,

                              letterSpacing:
                                  1.2,
                            ),
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  30,
                            ),

                            child: Text(

                              usersCount < 2

                                  ? "Waiting for another user to join"

                                  : isTalking

                                      ? "Live voice broadcasting"

                                      : "Press and hold to speak globally",

                              textAlign:
                                  TextAlign.center,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,

                                fontSize:
                                    16,

                                height:
                                    1.5,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          if (usersCount >= 2)

                            Container(

                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    18,

                                vertical:
                                    8,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors.white12,

                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),
                              ),

                              child: Text(

                                isTalking
                                    ? "LIVE"
                                    : "READY",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight.bold,

                                  letterSpacing:
                                      1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          const Spacer(),
        ],
      ),
    ),
  ),
);

}
}
