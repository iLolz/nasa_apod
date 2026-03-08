import 'package:equatable/equatable.dart';

import '../../domain/entities/apod_image.dart';
import '../../domain/entities/pagination.dart';

enum HomeStatus {
  initial,
  initialLoading,
  loaded,
  loadingMore,
  initialError,
  loadMoreError,
}

enum HomeErrorType {
  network,
  parsing,
  unknown,
}

class HomeError extends Equatable {
  final HomeErrorType type;
  final String message;

  const HomeError({
    required this.type,
    required this.message,
  });

  @override
  List<Object?> get props => [type, message];
}

class HomeState extends Equatable {
  static const _unset = Object();

  final HomeStatus status;
  final Pagination pagination;
  final List<ApodImage> images;
  final HomeError? error;

  const HomeState({
    required this.status,
    required this.pagination,
    this.images = const [],
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      status: HomeStatus.initial,
      pagination: Pagination.empty(),
    );
  }

  bool get isInitialLoading =>
      status == HomeStatus.initial || status == HomeStatus.initialLoading;

  bool get isLoaded => status == HomeStatus.loaded;

  bool get hasInitialError => status == HomeStatus.initialError;

  bool get isLoadingMore => status == HomeStatus.loadingMore;

  bool get hasLoadMoreError => status == HomeStatus.loadMoreError;

  bool get showsLoadedContent =>
      status == HomeStatus.loaded ||
      status == HomeStatus.loadingMore ||
      status == HomeStatus.loadMoreError;

  bool get canLoadMore =>
      status == HomeStatus.loaded || status == HomeStatus.loadMoreError;

  HomeState copyWith({
    HomeStatus? status,
    Pagination? pagination,
    List<ApodImage>? images,
    Object? error = _unset,
  }) {
    return HomeState(
      status: status ?? this.status,
      pagination: pagination ?? this.pagination,
      images: images ?? this.images,
      error: identical(error, _unset) ? this.error : error as HomeError?,
    );
  }

  @override
  List<Object?> get props => [status, pagination, images, error];
}
