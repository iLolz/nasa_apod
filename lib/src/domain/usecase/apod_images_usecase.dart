import '../../data/repository/images_repository.dart';
import '../entities/image_info.dart';
import '../entities/pagination.dart';

class ApodImagesUsecase {
  final ImagesRepository _repository;

  ApodImagesUsecase(this._repository);

  Future<List<ApodImage>> call(Pagination pagination) async {
    return await _repository.getImages(pagination);
  }
}
