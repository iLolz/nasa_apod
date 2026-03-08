import 'package:nasa_apod/src/data/repository/images_repository.dart';
import 'package:nasa_apod/src/domain/entities/apod_image.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

class TestHomeCubit extends HomeCubit {
  TestHomeCubit({
    required HomeState initialState,
  }) : super(NoopApodImagesUsecase()) {
    emit(initialState);
  }

  int getImagesCalls = 0;
  int loadMoreImagesCalls = 0;

  @override
  Future<void> getImages() async {
    getImagesCalls++;
  }

  @override
  Future<void> loadMoreImages() async {
    loadMoreImagesCalls++;
  }

  void setState(HomeState state) {
    emit(state);
  }
}

class NoopApodImagesUsecase extends ApodImagesUsecase {
  NoopApodImagesUsecase() : super(NoopImagesRepository());

  @override
  Future<List<ApodImage>> call(Pagination pagination) async {
    return [];
  }
}

class NoopImagesRepository implements ImagesRepository {
  @override
  Future<List<ApodImage>> getImages(Pagination pagination) async {
    return [];
  }
}

Pagination testPagination() {
  return Pagination(
    startDate: DateTime(2024, 1, 10),
    endDate: DateTime(2024, 1, 20),
    thumbs: true,
  );
}

ApodImage testImage({required String title}) {
  return ApodImage(
    previewUrl: 'https://example.com/image.jpg',
    contentUrl: 'https://example.com/hd.jpg',
    title: title,
    description: 'Description',
    date: DateTime(2024, 1, 20),
    displayDate: '20/01/2024',
    mediaType: ApodMediaType.image,
  );
}
