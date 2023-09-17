import 'package:nasa_apod/src/domain/entities/pagination.dart';

import '../../domain/entities/image_info.dart';

abstract class ImagesRepository {
  const ImagesRepository();

  Future<List<ApodImage>> getImages(Pagination pagination);
}
