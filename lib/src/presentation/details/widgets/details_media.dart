import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../domain/entities/apod_image.dart';

class DetailsMedia extends StatefulWidget {
  const DetailsMedia({
    required this.image,
    super.key,
  });

  final ApodImage image;

  @override
  State<DetailsMedia> createState() => _DetailsMediaState();
}

class _DetailsMediaState extends State<DetailsMedia> {
  static const _heroTransitionDuration = Duration(milliseconds: 300);

  YoutubePlayerController? _controller;
  var _showHdImage = false;
  ModalRoute<dynamic>? _route;
  Animation<double>? _routeAnimation;

  String get _detailsImageUrl {
    if (widget.image.hasValidContentUrl) {
      return widget.image.contentUrl;
    }

    return widget.image.previewUrl;
  }

  @override
  void initState() {
    super.initState();

    if (widget.image.isVideo && widget.image.hasValidContentUrl) {
      _controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(widget.image.contentUrl) ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

    if (!widget.image.isVideo && widget.image.hasValidContentUrl) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await precacheImage(
          CachedNetworkImageProvider(_detailsImageUrl),
          context,
        );

        await Future<void>.delayed(_heroTransitionDuration);

        if (!mounted) {
          return;
        }

        setState(() {
          _showHdImage = true;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);

    if (_route == route) {
      return;
    }

    _routeAnimation?.removeStatusListener(_handleRouteStatusChange);
    _route = route;
    _routeAnimation = route?.animation;
    _routeAnimation?.addStatusListener(_handleRouteStatusChange);
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_handleRouteStatusChange);
    _controller?.dispose();
    super.dispose();
  }

  void _handleRouteStatusChange(AnimationStatus status) {
    if (!mounted) {
      return;
    }

    if (status == AnimationStatus.reverse && _showHdImage) {
      setState(() {
        _showHdImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image.isVideo) {
      if (_controller != null) {
        return YoutubePlayer(controller: _controller!);
      }

      return _buildImage(context);
    }

    return _buildImage(context);
  }

  Widget _buildImage(BuildContext context) {
    if (!widget.image.hasValidPreviewUrl && !widget.image.hasValidContentUrl) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildImageLayer(context, ''),
      );
    }

    final previewUrl = widget.image.previewUrl;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: widget.image.heroTag,
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return _buildImageLayer(
                flightContext,
                previewUrl,
                key: const ValueKey('hero-flight-preview'),
              );
            },
            child: _buildImageLayer(
              context,
              previewUrl,
              key: const ValueKey('hero-preview'),
            ),
          ),
          if (_showHdImage && _detailsImageUrl != previewUrl)
            IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: 1,
                child: _buildImageLayer(
                  context,
                  _detailsImageUrl,
                  key: const ValueKey('hero-hd-overlay'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageLayer(
    BuildContext context,
    String imageUrl, {
    Key? key,
  }) {
    if (imageUrl.isEmpty) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const SizedBox(
          height: 240,
          child: Center(
            child: Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      key: key,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const SizedBox(
          height: 240,
          child: Center(
            child: Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      ),
    );
  }
}
