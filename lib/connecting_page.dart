import 'dart:async';

import 'package:flutter/material.dart';

import 'walkie_page.dart';

class ConnectingPage extends StatefulWidget {
  final String userID;

  final String userName;

  final String friendName;

  final String roomID;

  const ConnectingPage({
    super.key,
    required this.userID,
    required this.userName,
    required this.friendName,
    required this.roomID,
  });

  @override
  State<ConnectingPage> createState() =>
      _ConnectingPageState();
}

class _ConnectingPageState
    extends State<ConnectingPage>
    with SingleTickerProviderStateMixin {

  late AnimationController
      pulseController;

  @override
  void initState() {
    super.initState();

    pulseController =
        AnimationController(
      vsync: this,

      duration:
          const Duration(
        milliseconds: 1200,
      ),
    )..repeat(reverse: true);

    Timer(
      const Duration(
        seconds: 3,
      ),

      () {

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder:
                (context) =>
                    WalkiePage(
              userID:
                  widget.userID,

              userName:
                  widget.userName,

              friendName:
                  widget.friendName,

              roomID:
                  widget.roomID,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black,

      body: Stack(
        children: [

          // TOP GLOW
          Positioned(
            top: -140,
            left: -100,

            child: Container(
              width: 300,
              height: 300,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: Colors
                    .deepPurple
                    .withOpacity(
                  0.25,
                ),
              ),
            ),
          ),

          // BOTTOM GLOW
          Positioned(
            bottom: -160,
            right: -120,

            child: Container(
              width: 340,
              height: 340,

              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,

                color: Colors
                    .purple
                    .withOpacity(
                  0.2,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                children: [

                  // AVATAR
                  AnimatedBuilder(
                    animation:
                        pulseController,

                    builder:
                        (
                        context,
                        child,
                        ) {

                      return Transform
                          .scale(
                        scale:
                            1 +
                                (pulseController.value *
                                    0.08),

                        child:
                            Container(
                          width:
                              230,

                          height:
                              230,

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

                          child:
                              Center(
                            child:
                                Text(
                              widget
                                  .friendName
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
                                    90,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 55,
                  ),

                  Text(
                    "Connecting to ${widget.friendName}",

                    textAlign:
                        TextAlign.center,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,

                      fontSize:
                          32,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 40,
                    ),

                    child: Text(
                      "Establishing secure realtime voice connection...",

                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        color:
                            Colors.white70,

                        fontSize:
                            16,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  // SIGNAL ANIMATION
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children:
                        List.generate(
                      5,

                      (index) =>
                          AnimatedContainer(
                        duration:
                            Duration(
                          milliseconds:
                              400 +
                                  (index *
                                      100),
                        ),

                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              4,
                        ),

                        width:
                            10,

                        height:
                            25 +
                                (pulseController.value *
                                    55),

                        decoration:
                            BoxDecoration(
                          color: const Color(
                              0xffA855F7),

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 45,
                  ),

                  // STATUS CARD
                  Container(
                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),

                    padding:
                        const EdgeInsets.all(
                      22,
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

                    child: Row(
                      children: [

                        Container(
                          width:
                              16,

                          height:
                              16,

                          decoration:
                              const BoxDecoration(
                            color:
                                Colors.green,

                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        const SizedBox(
                          width:
                              14,
                        ),

                        const Expanded(
                          child: Text(
                            "Encrypted network handshake in progress",

                            style:
                                TextStyle(
                              color:
                                  Colors.white70,

                              fontSize:
                                  15,
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
}