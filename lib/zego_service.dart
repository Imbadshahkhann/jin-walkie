import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoService {

  static final ZegoService instance =
      ZegoService._internal();

  factory ZegoService() {
    return instance;
  }

  ZegoService._internal();

  final int appID = 2087406139;

  final String appSign =
      "774bb510881043f0092c8dfb222ba28412575a60efb6699788f80ec4c9376c94";

  bool isInitialized = false;

  Function(bool)? onConnectionState;

  Future<void> initialize() async {

    if (isInitialized) return;

    ZegoEngineProfile profile =
        ZegoEngineProfile(
      appID,
      ZegoScenario.Default,
      appSign: appSign,
    );

    await ZegoExpressEngine
        .createEngineWithProfile(
      profile,
    );

    // SPEAKER
    await ZegoExpressEngine
        .instance
        .setAudioRouteToSpeaker(
      true,
    );

    // MIC MUTED INITIALLY
    await ZegoExpressEngine
        .instance
        .muteMicrophone(
      true,
    );

    // LISTEN FOR OTHER USER STREAM
    ZegoExpressEngine.onRoomStreamUpdate =
        (
      roomID,
      updateType,
      streamList,
      extendedData,
    ) {

      if (updateType ==
          ZegoUpdateType.Add) {

        for (var stream
            in streamList) {

          // PLAY OTHER USER AUDIO
          ZegoExpressEngine.instance
              .startPlayingStream(
            stream.streamID,
          );

          if (onConnectionState !=
              null) {

            onConnectionState!(
              true,
            );
          }
        }
      }

      if (updateType ==
          ZegoUpdateType.Delete) {

        for (var stream
            in streamList) {

          ZegoExpressEngine.instance
              .stopPlayingStream(
            stream.streamID,
          );
        }

        if (onConnectionState !=
            null) {

          onConnectionState!(
            false,
          );
        }
      }
    };

    isInitialized = true;
  }

  Future<void> loginRoom({
    required String roomID,
    required String userID,
    required String userName,
  }) async {

    await initialize();

    ZegoUser user =
        ZegoUser(
      userID,
      userName,
    );

    await ZegoExpressEngine
        .instance
        .loginRoom(
      roomID,
      user,
    );

    // PUBLISH AUDIO
    await ZegoExpressEngine
        .instance
        .startPublishingStream(
      "${userID}_stream",
    );
  }

  Future<void> startTalking() async {

    await ZegoExpressEngine
        .instance
        .muteMicrophone(
      false,
    );
  }

  Future<void> stopTalking() async {

    await ZegoExpressEngine
        .instance
        .muteMicrophone(
      true,
    );
  }

  Future<void> leaveRoom() async {

    await ZegoExpressEngine
        .instance
        .stopPublishingStream();

    await ZegoExpressEngine
        .instance
        .logoutRoom();
  }

  Future<void> destroy() async {

    await ZegoExpressEngine
        .destroyEngine();

    isInitialized = false;
  }
}