import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() =>
      _SearchPageState();
}

class _SearchPageState
    extends State<SearchPage> {

  final searchController =
      TextEditingController();

  List users = [];

  bool isLoading = false;

  Set<String> sentRequests = {};

  Future<void> searchUser() async {

    setState(() {
      isLoading = true;
    });

    String searchText =
        searchController.text
            .trim()
            .toLowerCase();

    var result =
        await FirebaseFirestore
            .instance
            .collection("users")
            .get();

    users = result.docs.where((doc) {

      final data =
          doc.data();

      String username =
          (data["username"] ?? "")
              .toString()
              .toLowerCase();

      return username.contains(
        searchText,
      );
    }).toList();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> sendRequest(
    Map<String, dynamic> user,
  ) async {

    final currentUser =
        FirebaseAuth.instance
            .currentUser!;

    // SELF CHECK
    if (user["uid"] ==
        currentUser.uid) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "You cannot add yourself 😎",
          ),
        ),
      );

      return;
    }

    // CHECK EXISTING REQUEST
    var existing =
        await FirebaseFirestore
            .instance
            .collection(
              "friend_requests",
            )
            .where(
              "sender",
              isEqualTo:
                  currentUser.uid,
            )
            .where(
              "receiver",
              isEqualTo:
                  user["uid"],
            )
            .get();

    if (existing.docs.isNotEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Request already sent 🚀",
          ),
        ),
      );

      return;
    }

    // SAVE REQUEST
    await FirebaseFirestore
        .instance
        .collection(
          "friend_requests",
        )
        .add({

      "sender":
          currentUser.uid,

      "receiver":
          user["uid"],

      "senderName":
          currentUser.email!
              .split("@")[0],

      "receiverName":
          user["username"],

      "createdAt":
          Timestamp.now(),
    });

    setState(() {
      sentRequests.add(
        user["uid"],
      );
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Request sent to ${user["username"]}",
        ),
      ),
    );
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
                    "Search Users",

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize:
                          30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              // SEARCH FIELD
              Container(
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                          0xff18181B),

                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),

                child: TextField(
                  controller:
                      searchController,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                  ),

                  decoration:
                      InputDecoration(
                    border:
                        InputBorder.none,

                    hintText:
                        "Search username",

                    hintStyle:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          22,
                      vertical:
                          20,
                    ),

                    suffixIcon:
                        IconButton(
                      onPressed:
                          searchUser,

                      icon:
                          const Icon(
                        Icons.search,

                        color:
                            Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              if (isLoading)
                const CircularProgressIndicator(
                  color:
                      Colors.deepPurple,
                ),

              Expanded(
                child:
                    ListView.builder(
                  itemCount:
                      users.length,

                  itemBuilder:
                      (context,
                          index) {

                    var user =
                        users[index]
                            .data();

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 18,
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
                            width: 65,
                            height: 65,

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
                                20,
                              ),
                            ),

                            child:
                                Center(
                              child:
                                  Text(
                                user["username"]
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
                            width: 18,
                          ),

                          // INFO
                          Expanded(
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  user["username"],

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
                                      6,
                                ),

                                Text(
                                  user["email"],

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ADD BUTTON
                          GestureDetector(
                            onTap:
                                sentRequests.contains(
                                        user["uid"])
                                    ? null
                                    : () {

                                        sendRequest(
                                          user,
                                        );
                                      },

                            child:
                                Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    22,
                                vertical:
                                    14,
                              ),

                              decoration:
                                  BoxDecoration(
                                gradient:
                                    LinearGradient(
                                  colors:
                                      sentRequests.contains(
                                              user["uid"])
                                          ? [
                                              Colors.green,
                                              Colors.greenAccent,
                                            ]
                                          : [
                                              const Color(
                                                  0xff7C3AED),

                                              const Color(
                                                  0xffA855F7),
                                            ],
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),

                              child: Text(
                                sentRequests.contains(
                                        user["uid"])
                                    ? "SENT"
                                    : "ADD",

                                style:
                                    const TextStyle(
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