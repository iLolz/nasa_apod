import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';

abstract class ImagesLocalDataSource {
  const ImagesLocalDataSource();

  Future<List<ApodImageModel>?> getImages(PaginationModel pagination);

  Future<void> saveImages(
    PaginationModel pagination,
    List<ApodImageModel> images,
  );
}
