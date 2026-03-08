import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/apod_image.dart';
import '../../../home_cubit.dart';
import '../../home_state.dart';
import 'image_card.dart';
import 'load_more_error.dart';

class LoadedStateWidget extends StatefulWidget {
  const LoadedStateWidget({
    super.key,
  });

  @override
  State<LoadedStateWidget> createState() => _LoadedStateWidgetState();
}

class _LoadedStateWidgetState extends State<LoadedStateWidget> {
  static const _loadMoreOffset = 200.0;

  final scrollController = ScrollController();
  var _hasRequestedLoadMore = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (!scrollController.hasClients) {
        return;
      }

      final threshold =
          scrollController.position.maxScrollExtent - _loadMoreOffset;

      if (scrollController.position.pixels >= threshold &&
          !_hasRequestedLoadMore) {
        _hasRequestedLoadMore = true;
        context.read<HomeCubit>().loadMoreImages();
      } else if (scrollController.position.pixels < threshold) {
        _hasRequestedLoadMore = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final expandedHeight = (screenHeight / 3).clamp(220.0, 340.0);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: expandedHeight,
            collapsedHeight: kToolbarHeight + 8,
            surfaceTintColor: Colors.transparent,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.94),
            title: const Text('NASA APOD'),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxHeight < 210) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 88, 12, 16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primaryContainer.withValues(
                              alpha: 0.92,
                            ),
                            colorScheme.surface.withValues(alpha: 0.98),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          final contentHeight = innerConstraints.maxHeight;
                          final compact = contentHeight < 132;
                  final showTitle = contentHeight > 112;
                  final showSummary = contentHeight > 180;
                  final titleStyle = textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.05,
                    color: colorScheme.onSurface,
                    fontSize: compact ? 22 : 28,
                  );

                          return Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                compact ? 16 : 20,
                                compact ? 10 : 20,
                                compact ? 16 : 20,
                                compact ? 10 : 18,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface.withValues(
                                        alpha: 0.72,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: compact ? 10 : 12,
                                        vertical: compact ? 4 : 6,
                                      ),
                                      child: Text(
                                        'Daily cosmic archive',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (showTitle) ...[
                                    SizedBox(height: compact ? 8 : 12),
                                    Text(
                                      'Astronomy Picture of the Day',
                                      maxLines: compact ? 1 : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: titleStyle,
                                    ),
                                  ],
                                  if (showSummary) ...[
                                    const SizedBox(height: 10),
                                    Text(
                                      'A scrollable archive of NASA imagery, '
                                      'videos, and the stories behind each '
                                      'observation.',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          BlocSelector<HomeCubit, HomeState, List<ApodImage>>(
            selector: (state) => state.images,
            builder: (context, images) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final image = images[index];

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      12,
                      index == 0 ? 8 : 0,
                      12,
                      12,
                    ),
                    child: ImageCard(image: image),
                  );
                },
                childCount: images.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocSelector<HomeCubit, HomeState, bool>(
              selector: (state) => state.hasLoadMoreError,
              builder: (context, state) =>
                  state ? const FailedToLoadMore() : const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocSelector<HomeCubit, HomeState, bool>(
              selector: (state) => state.isLoadingMore,
              builder: (context, state) => state
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const SliverSafeArea(
            sliver: SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ),
      ],
    );
  }
}
