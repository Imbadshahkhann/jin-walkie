import 'package:flutter/material.dart';

import 'zego_service.dart';

class WalkiePage extends StatefulWidget {

  final String userID;

  final String userName;

  final String friendName;

  final String roomID;

  const WalkiePage({
    super.key,
    required this.userID,
    required this.userName,
    required this.friendName,
    required this.roomID,
  });

  @override
  State<WalkiePage> createState() =>
      _WalkiePageState();
}

class _WalkiePageState
    extends State<WalkiePage>
    with SingleTickerProviderStateMixin {

  bool isTalking = false;

  bool isConnected = false;

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
        milliseconds: 900,
      ),
    )..repeat(reverse: true);

    initializeWalkie();
  }

  Future<void> initializeWalkie() async {

    // REAL CONNECTION LISTENER
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
      roomID: widget.roomID,

      userID: widget.userID,

      userName: widget.userName,
    );
  }

  @override
  void dispose() {

    ZegoService.instance
        .leaveRoom();

    pulseController.dispose();

    super.dispose();
  }

  void startTalking() async {

    if (!isConnected) return;

    await ZegoService.instance
        .startTalking();

    setState(() {
      isTalking = true;
    });
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

      body: Stack(
        children: [

          // TOP GLOW
          Positioned(
            top: -120,
            left: -100,

            child: Container(
              width: 280,
              height: 280,

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
            bottom: -140,
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

                          Text(
                            widget.friendName,

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
                            height: 10,
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
                                  color: isConnected
                                      ? Colors.green
                                      : Colors.orange,

                                  shape:
                                      BoxShape.circle,
                                ),
                              ),

                              const SizedBox(
                                width:
                                    8,
                              ),

                              Text(
                                isConnected
                                    ? "Connected"
                                    : "Waiting for friend...",

                                style:
                                    TextStyle(
                                  color: isConnected
                                      ? Colors.green
                                      : Colors.orange,

                                  fontSize:
                                      16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // EXIT BUTTON
                      GestureDetector(
                        onTap: () async {

                          await ZegoService
                              .instance
                              .leaveRoom();

                          Navigator.pop(
                            context,
                          );
                        },

                        child: Container(
                          padding:
                              const EdgeInsets
                                  .all(
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
                              20,
                            ),
                          ),

                          child:
                              const Icon(
                            Icons.call_end,

                            color:
                                Colors.white,

                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // MAIN MIC
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
                        scale: isTalking
                            ? 1 +
                                (pulseController.value *
                                    0.08)
                            : 1,

                        child:
                            GestureDetector(
                          onLongPressStart:
                              (_) {

                            startTalking();
                          },

                          onLongPressEnd:
                              (_) {

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
                                    ? 330
                                    : 290,

                            height:
                                isTalking
                                    ? 330
                                    : 290,

                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors:
                                    !isConnected
                                        ? [
                                            Colors.grey,
                                            Colors.grey,
                                          ]
                                        : isTalking
                                            ? [
                                                Colors.red,
                                                Colors.deepOrange,
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

                              boxShadow: [
                                BoxShadow(
                                  color:
                                      !isConnected
                                          ? Colors.grey.withOpacity(
                                              0.4,
                                            )
                                          : isTalking
                                              ? Colors.red.withOpacity(
                                                  0.75,
                                                )
                                              : Colors.deepPurple.withOpacity(
                                                  0.7,
                                                ),

                                  blurRadius:
                                      80,

                                  spreadRadius:
                                      14,
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
                                  isTalking
                                      ? Icons.mic
                                      : Icons.mic_none,

                                  color:
                                      Colors.white,

                                  size:
                                      130,
                                ),

                                const SizedBox(
                                  height:
                                      24,
                                ),

                                // WAVEFORM
                                if (isTalking)

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,

                                    children:
                                        List.generate(
                                      5,

                                      (index) =>
                                          AnimatedContainer(
                                        duration:
                                            Duration(
                                          milliseconds:
                                              300 +
                                                  (index * 100),
                                        ),

                                        margin:
                                            const EdgeInsets.symmetric(
                                          horizontal:
                                              4,
                                        ),

                                        width:
                                            10,

                                        height:
                                            20 +
                                                (pulseController.value *
                                                    50),

                                        decoration:
                                            BoxDecoration(
                                          color:
                                              Colors.white,

                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                const SizedBox(
                                  height:
                                      20,
                                ),

                                Text(
                                  !isConnected
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
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      10,
                                ),

                                Text(
                                  !isConnected
                                      ? "Waiting for friend to connect..."
                                      : isTalking
                                          ? "Live realtime voice transmitting..."
                                          : "Press and hold to speak instantly",

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,

                                    fontSize:
                                        16,
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
                        30,
                      ),

                      border: Border.all(
                        color: Colors
                            .deepPurple
                            .withOpacity(
                          0.4,
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
                              BoxDecoration(
                            color: !isConnected
                                ? Colors.orange
                                : isTalking
                                    ? Colors.red
                                    : Colors.green,

                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        const SizedBox(
                          width:
                              14,
                        ),

                        Expanded(
                          child: Text(
                            !isConnected
                                ? "Realtime private channel waiting for friend..."
                                : isTalking
                                    ? "Live realtime voice transmission active..."
                                    : "Connected to private encrypted walkie channel",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,

                              fontSize:
                                  16,
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