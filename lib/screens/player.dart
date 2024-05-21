import 'dart:convert';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../global.dart';
import '../helpers/error.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;
  YoutubeExplode youtube = YoutubeExplode();
  String likes = 'Like';
  String dislikes = 'Dislike';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Global.id,
      flags: const YoutubePlayerFlags(),
    );
    updateLikesAndDislikes();
  }

  String formatNumber(int num) {
    if (num >= 1000000000) {
      return '${(num / 1000000000).toStringAsFixed(1)}B';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    } else {
      return num.toString();
    }
  }

  Future<Map<String, dynamic>> getVotes(String id) async {
    String url = 'https://returnyoutubedislikeapi.com/votes?videoId=$id';
    Response response = await get(Uri.parse(url));
    Map<String, dynamic> body = jsonDecode(response.body);
    return body;
  }

  Future<CommentsList?> getVideoComments() async {
    CommentsList? comments =
        await youtube.videos.commentsClient.getComments(Global.data);
    return comments;
  }

  Future<CommentsList?> getCommentReplies(Comment comment) async {
    CommentsList? replies =
        await youtube.videos.commentsClient.getReplies(comment);
    return replies;
  }

  void updateLikesAndDislikes() async {
    Map<String, dynamic> result = await getVotes(Global.id);
    setState(
      () {
        likes = result.containsKey('likes')
            ? formatNumber(
                result['likes'],
              )
            : 'Like';
        dislikes = result.containsKey('dislikes')
            ? formatNumber(
                result['dislikes'],
              )
            : 'Dislike';
      },
    );
  }

  void shareLink(BuildContext context) {
    String link = 'https://www.youtube.com/watch?v=${Global.id}';
    Clipboard.setData(
      ClipboardData(text: link),
    ).then(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link copied to clipboard')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        _controller.addListener(() {});
      },
    );

    return SafeArea(
      child: Scaffold(
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
          ),
          builder: (BuildContext context, Widget player) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                player,
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    Global.data.title,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      buttons(
                        Icons.thumb_up_outlined,
                        likes,
                        runOnPressed: (_) =>
                            ErrorHandler.toastUnimplemented(context),
                      ),
                      buttons(
                        Icons.thumb_down_alt_outlined,
                        dislikes,
                        runOnPressed: (_) =>
                            ErrorHandler.toastUnimplemented(context),
                      ),
                      buttons(
                        Icons.share_outlined,
                        'Share',
                        runOnPressed: (_) => shareLink(context),
                      ),
                      buttons(
                        Icons.add_box_outlined,
                        'Save',
                        runOnPressed: (_) =>
                            ErrorHandler.toastUnimplemented(context),
                      ),
                      buttons(
                        Icons.download_outlined,
                        'Download',
                        runOnPressed: (_) =>
                            ErrorHandler.toastUnimplemented(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.person_outline,
                          size: 25,
                        ),
                      ),
                    ),
                    Text(
                      Global.data.author,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        ErrorHandler.toastUnimplemented(context);
                      },
                      child: const Text(
                        'Subscribe',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ErrorHandler.toastUnimplemented(context);
                      },
                      icon: const Icon(Icons.notifications),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    Global.data.uploadDateRaw ?? 'N/a',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    Global.data.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FutureBuilder<CommentsList?>(
                  future: getVideoComments(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<CommentsList?> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: snapshot.data?.length ?? 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                snapshot.data?[index].toString() ??
                                    'No comments',
                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buttons(
    dynamic icon,
    String text, {
    required Function(BuildContext context) runOnPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          IconButton(
            onPressed: () {
              runOnPressed(context);
            },
            icon: Icon(icon),
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key});
  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Global.data.title),
            ElevatedButton(
              child: const Text('Download'),
              onPressed: () async {
                StreamManifest manifest = await YoutubeExplode()
                    .videos
                    .streamsClient
                    .getManifest(Global.id);
                manifest.muxed.withHighestBitrate();
              },
            ),
          ],
        ),
      ),
    );
  }
}
