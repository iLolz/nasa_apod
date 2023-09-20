import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/apod_image.dart';
import '../../domain/entities/pagination.dart';

extension When on HomeState {
  Widget whenBuild({
    required Widget loading,
    required Widget loaded,
    required Widget error,
  }) {
    if (this is HomeStateLoading) {
      return loading;
    } else if (this is HomeStateLoaded) {
      return loaded;
    } else if (this is HomeStateError) {
      return error;
    } else {
      throw Exception('Unknown state');
    }
  }
}

abstract class HomeState extends Equatable {
  final Pagination pagination;

  const HomeState(this.pagination);

  @override
  List<Object?> get props => [pagination];
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading(super.pagination);
}

class HomeStateLoaded extends HomeState {
  final List<ApodImage> images;

  const HomeStateLoaded(
    super.pagination,
    this.images,
  );

  HomeStateLoaded add(
    List<ApodImage> newImages,
  ) {
    return HomeStateLoaded(
      pagination.next(),
      [...images, ...newImages],
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        images,
      ];
}

class HomeStateLoadingMore extends HomeStateLoaded {
  const HomeStateLoadingMore(
    super.pagination,
    super.images,
  );
}

class HomeStateLoadingMoreError extends HomeStateLoaded {
  const HomeStateLoadingMoreError(
    super.pagination,
    super.images,
  );
}

class HomeStateError extends HomeState {
  const HomeStateError(super.pagination);

  @override
  List<Object?> get props => [super.props];
}
