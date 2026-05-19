import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'walkie_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() =>
      _FriendsPageState();
}

class _FriendsPageState
    extends State<FriendsPage> {

  final currentUser =
      FirebaseAuth.instance.currentUser!;

  String createRoomID(
    String uid1,
    String uid2,
  ) {

    List<String> ids = [
      uid1,
      uid2,
    ];

    ids.sort();

    return ids.join("_");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

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
                        Icons.arrow_back,
                        color:
                            Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  const Text(
                    "Friends",

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize: 30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                            "friends",
                          )
                          .snapshots(),

                  builder:
                      (
                      context,
                      snapshot,
                      ) {

                    if (!snapshot
                        .hasData) {

                      return const Center(
                        child:
                            CircularProgressIndicator(
                          color:
                              Colors.deepPurple,
                        ),
                      );
                    }

                    final docs =
                        snapshot.data!.docs;

                    final myFriends =
                        docs.where((doc) {

                      final data =
                          doc.data();

                      return data[
                                  "user1"] ==
                              currentUser.uid ||
                          data[
                                  "user2"] ==
                              currentUser.uid;
                    }).toList();

                    if (myFriends
                        .isEmpty) {

                      return const Center(
                        child: Text(
                          "No Friends Yet",

                          style: TextStyle(
                            color:
                                Colors.white54,

                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount:
                          myFriends.length,

                      itemBuilder:
                          (
                          context,
                          index,
                          ) {

                        final data =
                            myFriends[
                                    index]
                                .data();

                        String friendUID =
                            data["user1"] ==
                                    currentUser.uid
                                ? data[
                                    "user2"]
                                : data[
                                    "user1"];

                        return StreamBuilder<
                            DocumentSnapshot<
                                Map<String,
                                    dynamic>>>(
                          stream:
                              FirebaseFirestore
                                  .instance
                                  .collection(
                                    "users",
                                  )
                                  .doc(
                                    friendUID,
                                  )
                                  .snapshots(),

                          builder:
                              (
                              context,
                              userSnapshot,
                              ) {

                            if (!userSnapshot
                                .hasData) {

                              return const SizedBox();
                            }

                            final doc =
                                userSnapshot
                                    .data;

                            if (doc ==
                                    null ||
                                !doc.exists ||
                                doc.data() ==
                                    null) {

                              return const SizedBox();
                            }

                            final userData =
                                doc.data()!;

                            bool isOnline =
                                userData[
                                        "isOnline"] ??
                                    false;

                            String username =
                                userData[
                                        "username"] ??
                                    "Unknown User";

                            String roomID =
                                createRoomID(
                              currentUser.uid,
                              friendUID,
                            );

                            return GestureDetector(
                              onLongPress:
                                  () async {

                                bool? confirm =
                                    await showDialog(
                                  context:
                                      context,

                                  builder:
                                      (
                                      context,
                                      ) {

                                    return AlertDialog(
                                      backgroundColor:
                                          const Color(
                                        0xff18181B,
                                      ),

                                      title:
                                          const Text(
                                        "Remove Friend",

                                        style:
                                            TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),

                                      content:
                                          Text(
                                        "Remove $username from friends?",

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white70,
                                        ),
                                      ),

                                      actions: [

                                        TextButton(
                                          onPressed:
                                              () {

                                            Navigator.pop(
                                              context,
                                              false,
                                            );
                                          },

                                          child:
                                              const Text(
                                            "Cancel",
                                          ),
                                        ),

                                        TextButton(
                                          onPressed:
                                              () {

                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },

                                          child:
                                              const Text(
                                            "Remove",

                                            style:
                                                TextStyle(
                                              color:
                                                  Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm ==
                                    true) {

                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                        "friends",
                                      )
                                      .doc(
                                        myFriends[index]
                                            .id,
                                      )
                                      .delete();

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(
                                        "$username removed",
                                      ),
                                    ),
                                  );
                                }
                              },

                              child:
                                  Container(
                                margin:
                                    const EdgeInsets.only(
                                  bottom:
                                      18,
                                ),

                                padding:
                                    const EdgeInsets.all(
                                  18,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      const Color(
                                    0xff18181B,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    24,
                                  ),
                                ),

                                child: Row(
                                  children: [

                                    // AVATAR
                                    Container(
                                      width:
                                          70,

                                      height:
                                          70,

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
                                          22,
                                        ),
                                      ),

                                      child:
                                          Center(
                                        child:
                                            Text(
                                          username
                                              .toString()
                                              .substring(
                                                0,
                                                1,
                                              )
                                              .toUpperCase(),

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,

                                            fontSize:
                                                28,

                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                          18,
                                    ),

                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [

                                          Text(
                                            username,

                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,

                                              fontSize:
                                                  22,

                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height:
                                                8,
                                          ),

                                          Row(
                                            children: [

                                              Container(
                                                width:
                                                    12,

                                                height:
                                                    12,

                                                decoration:
                                                    BoxDecoration(
                                                  color: isOnline
                                                      ? Colors.green
                                                      : Colors.red,

                                                  shape:
                                                      BoxShape.circle,
                                                ),
                                              ),

                                              const SizedBox(
                                                width:
                                                    8,
                                              ),

                                              Text(
                                                isOnline
                                                    ? "Online"
                                                    : "Offline",

                                                style:
                                                    TextStyle(
                                                  color: isOnline
                                                      ? Colors.green
                                                      : Colors.red,

                                                  fontSize:
                                                      15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // TALK BUTTON
                                    GestureDetector(
                                      onTap:
                                          () {

                                        Navigator.push(
                                          context,

                                          MaterialPageRoute(
                                            builder:
                                                (
                                                context,
                                                ) =>
                                                    WalkiePage(
                                              userID:
                                                  currentUser.uid,

                                              userName:
                                                  currentUser.email!
                                                      .split("@")[0],

                                              friendName:
                                                  username,

                                              roomID:
                                                  roomID,
                                            ),
                                          ),
                                        );
                                      },

                                      child:
                                          Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal:
                                              22,

                                          vertical:
                                              16,
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
                                            18,
                                          ),
                                        ),

                                        child:
                                            const Text(
                                          "TALK",

                                          style:
                                              TextStyle(
                                            color:
                                                Colors.white,

                                            fontWeight:
                                                FontWeight.bold,

                                            fontSize:
                                                15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}