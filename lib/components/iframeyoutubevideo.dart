import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IframeYoutubeVideo extends StatefulWidget {
  final String keyMovie;
  const IframeYoutubeVideo({super.key, required this.keyMovie});

  @override
  State<IframeYoutubeVideo> createState() => _IframeYoutubeVideoState();
}

class _IframeYoutubeVideoState extends State<IframeYoutubeVideo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final String key = widget.keyMovie;
    final videoURL = "https://www.youtube.com/watch?v=$key";
    final videoID = YoutubePlayer.convertUrlToId(videoURL);

    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: false,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.red,
          ),
        )
      ],
    );
  }
}
