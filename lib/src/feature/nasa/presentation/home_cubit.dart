import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/services/error_service.dart';
import '../../../core/utils/exceptions.dart';
import '../domain/entities/pagination.dart';
import '../domain/usecase/apod_images_usecase.dart';
import 'home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApodImagesUsecase usecase;

  HomeCubit(this.usecase) : super(HomeStateLoading(Pagination.empty()));

  Future<void> getImages() async {
    try {
      emit(HomeStateLoading(state.pagination));
      final response = await usecase.call(null);
      emit(HomeStateLoaded(state.pagination.next(), response));
    } catch (e) {
      emit(HomeStateError(state.pagination));
      throw e;
    }
  }

  Future<void> loadMoreSales() async {
    if (state is HomeStateLoadingMore) return;
    final initialState = state as HomeStateLoaded;
    return await ErrorHandler<Future<void>>().handle(
      () async {
        emit(
          HomeStateLoadingMore(
            initialState.pagination,
            initialState.images,
          ),
        );

        final nextPage = initialState.pagination.next();

        final response = await usecase.call(initialState.images);

        emit(
          HomeStateLoaded(
            nextPage,
            [...initialState.images, ...response],
          ),
        );
      },
      onDefault: (e) {
        emit(HomeStateError(initialState.pagination));
      },
    );
  }
}

class ErrorHandler<T> {
  final errorService = GetIt.instance.get<ErrorService>();
  T handle(
    T Function() callback, {
    required Function(Object) onDefault,
    Function(BaseException)? onBase,
    Function(UsecaseException)? onUsecase,
    Function(NetworkException)? onNetwork,
    Function(DataSourceException)? onDataSource,
    Function(RepositoryException)? onRepository,
    Function(SubmitException)? onSubmit,
  }) {
    try {
      return callback();
    } on UsecaseException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onUsecase?.call(e) ?? onDefault.call(e);
    } on NetworkException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onNetwork?.call(e) ?? onDefault.call(e);
    } on DataSourceException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onDataSource?.call(e) ?? onDefault.call(e);
    } on RepositoryException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onRepository?.call(e) ?? onDefault.call(e);
    } on SubmitException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onSubmit?.call(e) ?? onDefault.call(e);
    } on BaseException catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onBase?.call(e) ?? onDefault.call(e);
    } catch (e, s) {
      errorService.recordError(e, stackTrace: s);
      return onDefault.call(e) ?? e;
    }
  }
}
