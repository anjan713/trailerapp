import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class MyYouTubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  MyYouTubePlayer({Key key,@required this.controller}) : super(key: key);

  @override
  _MyYouTubePlayerState createState() => _MyYouTubePlayerState(controller);
}

class _MyYouTubePlayerState extends State<MyYouTubePlayer> {
  final YoutubePlayerController controller;

  _MyYouTubePlayerState(this.controller);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: controller,
            ),
          ),
          Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                  color: Colors.white,
                  icon: Icon(EvaIcons.closeCircle),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }))
        ],
      ),
    );
  }
}
