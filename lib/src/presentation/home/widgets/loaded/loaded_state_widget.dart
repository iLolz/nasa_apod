import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/apod_image.dart';
import '../../../home_cubit.dart';
import '../../home_state.dart';
import 'images_list.dart';
import 'load_more_error.dart';

class LoadedStateWidget extends StatefulWidget {
  const LoadedStateWidget({
    super.key,
  });

  @override
  State<LoadedStateWidget> createState() => _LoadedStateWidgetState();
}

class _LoadedStateWidgetState extends State<LoadedStateWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<HomeCubit>().loadMoreSales();
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
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverAppBar(
          title: Text('NASA APOD'),
          floating: true,
        ),
        SliverToBoxAdapter(
          child: BlocSelector<HomeCubit, HomeState, List<ApodImage>>(
            selector: (state) => state is HomeStateLoaded ? state.images : [],
            builder: (context, images) => ImagesList(images),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocSelector<HomeCubit, HomeState, bool>(
            selector: (state) => state is HomeStateLoadingMoreError,
            builder: (context, state) =>
                state ? const FailedToLoadMore() : const SizedBox.shrink(),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocSelector<HomeCubit, HomeState, bool>(
            selector: (state) => state is HomeStateLoadingMore,
            builder: (context, state) => state
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ),
        ),
        const SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
