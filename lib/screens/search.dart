import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../global.dart';
import '../helpers/error.dart';
import '../helpers/prefs.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  YoutubeExplode youtube = YoutubeExplode();
  late Future<VideoSearchList> videoResult;

  Future<VideoSearchList> callSearchAPI(String query) async {
    VideoSearchList result = await youtube.search.search(query);
    if (result.length > 20) {
      youtube.close();
    }
    return result;
  }

  Future<List<String>> callSuggestionsAPI(String query) async {
    List<String> result = await youtube.search.getQuerySuggestions(query);
    if (result.length > 20) {
      youtube.close();
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  bool on = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(height: 5),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextField(
                    onTap: () {
                      setState(
                        () {
                          on = true;
                        },
                      );
                    },
                    controller: searchController,
                    onChanged: (String val) {},
                    onSubmitted: (String val) async {
                      on = false;
                      Global.searchList.add(searchController.text);
                      Global.searchList = Global.searchList.toSet().toList();
                      PrefsManager.writeData('searchList', Global.searchList);
                      videoResult = callSearchAPI(searchController.text);
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search YouTube',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ErrorHandler.toastUnimplemented(context);
                  },
                  icon: const Icon(Icons.mic),
                ),
              ],
            ),
            Expanded(
              child: (on)
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            on = false;
                            searchController.text = Global.searchList[i];
                            videoResult = callSearchAPI(searchController.text);
                            setState(() {});
                          },
                          leading: const Icon(Icons.history),
                          title: Text(
                            Global.searchList[i],
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: const Icon(Icons.arrow_upward_outlined),
                        );
                      },
                      itemCount: Global.searchList.length,
                    )
                  : FutureBuilder<VideoSearchList>(
                      future: videoResult,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<VideoSearchList> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ListView(
                            children:
                                snapshot.data!.map<Widget>(listItem).toList(),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(Video video) {
    return GestureDetector(
      onTap: () {
        Global.data = video;
        Global.id = video.id.toString();
        setState(() {});
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
            padding:
                const EdgeInsets.only(right: 15, left: 10, top: 5, bottom: 20),
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
