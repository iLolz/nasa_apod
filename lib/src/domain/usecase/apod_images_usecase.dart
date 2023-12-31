import '../../core/utils/exceptions.dart';
import '../../data/repository/images_repository.dart';
import '../entities/apod_image.dart';
import '../entities/pagination.dart';

class ApodImagesUsecase {
  final ImagesRepository _repository;

  ApodImagesUsecase(this._repository);

  Future<List<ApodImage>> call(Pagination pagination) async {
    try {
      return await _repository.getImages(pagination);
    } catch (e) {
      if (e is BaseException) rethrow;

      throw UsecaseException(e.toString());
    }
  }
}
