import '../../domain/entities/apod_image.dart';
import '../../domain/entities/pagination.dart';

abstract class ImagesRepository {
  const ImagesRepository();

  Future<List<ApodImage>> getImages(Pagination pagination);
}
