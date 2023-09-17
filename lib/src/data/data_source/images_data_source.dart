import 'package:nasa_apod/src/data/models/image_info_model.dart';

import '../models/pagination_model.dart';

abstract class ImageDataSource {
  const ImageDataSource();

  Future<List<ImageInfoModel>> getImages(PaginationModel p);
}
