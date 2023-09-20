import 'package:nasa_apod/src/data/models/apod_image_model.dart';

import '../models/pagination_model.dart';

abstract class ImageDataSource {
  const ImageDataSource();

  Future<List<ApodImageModel>> getImages(PaginationModel p);
}
