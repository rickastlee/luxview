import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  YoutubeExplode youtube = YoutubeExplode();
  late Future<VideoSearchList> videoResult;

  Future<VideoSearchList> callAPI() async {
    VideoSearchList result = await youtube.search.search('Flutter Tutorials');
    if (result.length > 20) {
      youtube.close();
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    videoResult = callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoSearchList>(
      future: videoResult,
      builder: (BuildContext context, AsyncSnapshot<VideoSearchList> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: const Row(
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_filled,
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'YouTube',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('search_page');
                    },
                    icon: const Icon(
                      Icons.search,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('settings_page');
                    },
                    icon: const Icon(
                      Icons.settings,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.map<Widget>(listItem).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget listItem(Video video) {
    return GestureDetector(
      onTap: () {
        Global.data = video;
        Global.id = video.id.toString();
        Navigator.of(context).pushNamed('player_page');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: CachedNetworkImageProvider(video.thumbnails.highResUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 10,
              top: 5,
              bottom: 20,
            ),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 20,
                  child: Icon(
                    Icons.person_outline,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        video.author,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
