import 'package:nasa_apod/src/domain/entities/pagination.dart';

import '../../domain/entities/apod_image.dart';

abstract class ImagesRepository {
  const ImagesRepository();

  Future<List<ApodImage>> getImages(Pagination pagination);
}
