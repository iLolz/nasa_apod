import 'package:nasa_apod/src/data/models/image_info_model.dart';

import '../../domain/entities/pagination.dart';

abstract class ImageDataSource {
  Future<List<ImageInfoModel>> getImages(Pagination p);
}
