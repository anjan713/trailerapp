import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sliver_fab/sliver_fab.dart';
import 'package:http/http.dart' as http;
import 'video_Screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsVideoScreen extends StatefulWidget {
  Map moviedetails = {};

  DetailsVideoScreen(this.moviedetails);

  @override
  _DetailsVideoScreenState createState() => _DetailsVideoScreenState();
}

class _DetailsVideoScreenState extends State<DetailsVideoScreen> {
  Map<String, dynamic> videoList = {};

  @override
  void initState() {
    super.initState();
    fetchVideo();
  }

  fetchVideo() async {
    var movieId = widget.moviedetails["id"];

    var api = await http.get(
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=6d832dc729465b6e297c8c4c7793b76c");

    var myResult = jsonDecode(api.body);
    videoList.addAll(myResult);
  }

  @override
  void dispose() {
    widget.moviedetails = {};
    videoList = {};

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(right: 20.0),
          floatingWidget: FloatingActionButton(
            onPressed: () {
             Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => MyYouTubePlayer(
                        controller: YoutubePlayerController(
                            initialVideoId: videoList["results"][0]["key"]),
                      )));
            },
            child: Icon(Icons.play_arrow),
          ),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.moviedetails["title"],
                  maxLines: 2,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w500${widget.moviedetails["backdrop_path"]}"))),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0),
                          ])),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Ratings:${widget.moviedetails["vote_average"].toString()}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.moviedetails["overview"],
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ])),
            ),
          ],
        );
      }),
    );
  }
}
