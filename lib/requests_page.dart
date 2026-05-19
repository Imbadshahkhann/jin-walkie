import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  Future<void> acceptRequest(
    BuildContext context,
    QueryDocumentSnapshot request,
  ) async {
    final currentUser =
        FirebaseAuth.instance
            .currentUser!;

    // CHECK EXISTING FRIEND
    var existing =
        await FirebaseFirestore.instance
            .collection("friends")
            .get();

    bool alreadyFriend =
        existing.docs.any((friend) {
      return (friend["user1"] ==
                  currentUser.uid &&
              friend["user2"] ==
                  request["sender"]) ||
          (friend["user2"] ==
                  currentUser.uid &&
              friend["user1"] ==
                  request["sender"]);
    });

    if (!alreadyFriend) {
      await FirebaseFirestore.instance
          .collection("friends")
          .add({
        "user1": currentUser.uid,
        "user1Name":
            currentUser.email,

        "user2":
            request["sender"],

        "user2Name":
            request["senderName"],

        "createdAt":
            DateTime.now(),

        "isOnline": true,
      });
    }

    // DELETE REQUEST
    await FirebaseFirestore.instance
        .collection(
          "friend_requests",
        )
        .doc(request.id)
        .delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Friend added successfully 🚀",
        ),
      ),
    );
  }

  Future<void> rejectRequest(
    QueryDocumentSnapshot request,
  ) async {
    await FirebaseFirestore.instance
        .collection(
          "friend_requests",
        )
        .doc(request.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        FirebaseAuth.instance
            .currentUser!;

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
                        "Requests",

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
                    height: 30,
                  ),

                  Expanded(
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore
                              .instance
                              .collection(
                                "friend_requests",
                              )
                              .snapshots(),

                      builder:
                          (context,
                              snapshot) {

                        if (!snapshot
                            .hasData) {
                          return const Center(
                            child:
                                CircularProgressIndicator(
                              color: Colors
                                  .deepPurple,
                            ),
                          );
                        }

                        var allRequests =
                            snapshot
                                .data!.docs;

                        var myRequests =
                            allRequests
                                .where(
                          (req) {
                            return req[
                                    "receiver"] ==
                                currentUser
                                    .uid;
                          },
                        ).toList();

                        if (myRequests
                            .isEmpty) {
                          return const Center(
                            child: Text(
                              "No Requests 😎",

                              style:
                                  TextStyle(
                                color:
                                    Colors.white,

                                fontSize:
                                    24,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return ListView
                            .builder(
                          itemCount:
                              myRequests
                                  .length,

                          itemBuilder:
                              (context,
                                  index) {

                            var request =
                                myRequests[
                                    index];

                            return Container(
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

                                border:
                                    Border.all(
                                  color: Colors
                                      .deepPurple
                                      .withOpacity(
                                    0.35,
                                  ),
                                ),
                              ),

                              child:
                                  Column(
                                children: [

                                  Row(
                                    children: [

                                      // AVATAR
                                      Container(
                                        width:
                                            68,

                                        height:
                                            68,

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
                                            request["senderName"]
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
                                                  30,

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
                                              request["senderName"],

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

                                            const Text(
                                              "Wants to connect with you",

                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors.white70,

                                                fontSize:
                                                    15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        22,
                                  ),

                                  Row(
                                    children: [

                                      // ACCEPT
                                      Expanded(
                                        child:
                                            GestureDetector(
                                          onTap:
                                              () {
                                            acceptRequest(
                                              context,
                                              request,
                                            );
                                          },

                                          child:
                                              Container(
                                            padding:
                                                const EdgeInsets.all(
                                              16,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              gradient:
                                                  const LinearGradient(
                                                colors: [
                                                  Colors.green,
                                                  Color(
                                                      0xff22C55E),
                                                ],
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(
                                                18,
                                              ),
                                            ),

                                            child:
                                                const Center(
                                              child:
                                                  Text(
                                                "ACCEPT",

                                                style:
                                                    TextStyle(
                                                  color:
                                                      Colors.white,

                                                  fontWeight:
                                                      FontWeight.bold,

                                                  fontSize:
                                                      16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width:
                                            16,
                                      ),

                                      // REJECT
                                      Expanded(
                                        child:
                                            GestureDetector(
                                          onTap:
                                              () {
                                            rejectRequest(
                                              request,
                                            );
                                          },

                                          child:
                                              Container(
                                            padding:
                                                const EdgeInsets.all(
                                              16,
                                            ),

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
                                                18,
                                              ),
                                            ),

                                            child:
                                                const Center(
                                              child:
                                                  Text(
                                                "REJECT",

                                                style:
                                                    TextStyle(
                                                  color:
                                                      Colors.white,

                                                  fontWeight:
                                                      FontWeight.bold,

                                                  fontSize:
                                                      16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}