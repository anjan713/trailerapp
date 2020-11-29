import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_screen_video.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var maviedetails = {};

  Future<void> fetchtrendingMovie() async {
    maviedetails = {};
    var api =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=6d832dc729465b6e297c8c4c7793b76c';
    var response = await http.get(api);
    var result = jsonDecode(response.body);
    maviedetails.addAll(result);
   
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trending',
              style: TextStyle(color: Colors.orange),
            ),
            Text(
              'Movies',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          // scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: fetchtrendingMovie(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occured'),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => DetailsVideoScreen(
                                maviedetails['results'][index])));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            maviedetails['results'][index]["title"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          Image(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500${maviedetails['results'][index]["poster_path"]}"),
                            height: 400,
                            width: 250,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // RaisedButton(
                          //   onPressed: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //           builder: (ctx) => DetailsVideoScreen(
                          //               maviedetails['results'][index])
                          //           // DetailsScreen(maviedetails['results'][index]
                          //           ),
                          //     );
                          //     // )
                          //     // ;
                          //   },
                          //   color: Colors.amber,
                          //   child: Text('Movie Details'),
                          // ),
                        ],
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
