import 'package:nasa_apod/src/domain/entities/pagination.dart';

import '../models/image_info_model.dart';

abstract class ImagesRepository {
  Future<List<ImageInfoModel>> getImages(Pagination pagination);
}
