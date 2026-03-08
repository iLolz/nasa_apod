import 'package:bloc/bloc.dart';

import '../core/utils/exceptions.dart';
import '../domain/usecase/apod_images_usecase.dart';
import 'home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApodImagesUsecase usecase;

  HomeCubit(this.usecase) : super(HomeState.initial());

  Future<void> getImages() async {
    final pagination = state.pagination;

    try {
      emit(
        state.copyWith(
          status: HomeStatus.initialLoading,
          error: null,
        ),
      );
      final response = await usecase.call(pagination);
      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          pagination: pagination.next(),
          images: response,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.initialError,
          pagination: pagination,
          error: _mapError(e),
        ),
      );
    }
  }

  Future<void> loadMoreImages() async {
    if (!state.canLoadMore || state.isLoadingMore) return;

    final pagination = state.pagination;
    final images = state.images;

    try {
      emit(
        state.copyWith(
          status: HomeStatus.loadingMore,
          error: null,
        ),
      );
      final response = await usecase.call(pagination.next());
      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          pagination: pagination.next(),
          images: [...images, ...response],
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.loadMoreError,
          pagination: pagination,
          images: images,
          error: _mapError(e),
        ),
      );
    }
  }

  HomeError _mapError(Object error) {
    if (error is NetworkException) {
      return HomeError(
        type: HomeErrorType.network,
        message: error.message,
      );
    }

    if (error is DataSourceException ||
        error is RepositoryException ||
        error is UsecaseException) {
      final baseError = error as BaseException;

      return HomeError(
        type: HomeErrorType.parsing,
        message: baseError.message,
      );
    }

    return HomeError(
      type: HomeErrorType.unknown,
      message: error.toString(),
    );
  }
}
