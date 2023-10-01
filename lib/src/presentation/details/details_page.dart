import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/utils/formatters.dart';
import '../../domain/entities/apod_image.dart';

class DetailsPage extends StatefulWidget {
  final ApodImage image;

  const DetailsPage({
    required this.image,
    super.key,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.image.imageUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.image.title),
      ),
      body: ListView(
        children: [
          if (widget.image.mediaType == 'video')
            YoutubePlayer(controller: controller)
          else
            Hero(
              tag: widget.image.title,
              child: CachedNetworkImage(
                imageUrl: widget.image.imageUrl,
              ),
            ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Photo shooted on: ${Formatters.toDateString(widget.image.date)}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: Text(
              widget.image.description,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
