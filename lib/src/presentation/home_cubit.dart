import 'package:bloc/bloc.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApodImagesUsecase usecase;

  HomeCubit(this.usecase) : super(HomeStateLoading(Pagination.empty()));

  Future<void> getImages() async {
    try {
      emit(HomeStateLoading(state.pagination));
      final response = await usecase.call(state.pagination);
      emit(HomeStateLoaded(state.pagination.next(), response));
    } catch (e) {
      emit(HomeStateError(state.pagination));
      throw e;
    }
  }

  Future<void> loadMoreSales() async {
    if (state is HomeStateLoadingMore) return;
    final initialState = state as HomeStateLoaded;
    try {
      emit(HomeStateLoadingMore(initialState.pagination, initialState.images));
      final response = await usecase.call(initialState.pagination.next());
      emit(
        HomeStateLoaded(
          initialState.pagination.next(),
          [...initialState.images, ...response],
        ),
      );
    } catch (e) {
      emit(HomeStateLoadingMoreError(state.pagination, initialState.images));
      rethrow;
    }
  }
}
