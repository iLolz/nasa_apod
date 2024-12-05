import '../../../../core/services/error_service.dart';
import '../../../../core/utils/exceptions.dart';

import '../../data/repository/images_repository.dart';
import '../entities/apod_image.dart';
import '../entities/pagination.dart';

class ApodImagesUsecase {
  final ImagesRepository _repository;
  final ErrorService errorService;

  ApodImagesUsecase(this._repository, this.errorService);

  final interval = 10;

  DateTime finalDate = DateTime.now();

  Future<List<ApodImage>> call(List<ApodImage>? images) async {
    try {
      final nextDate = nextFinalDate(finalDate, interval: interval);

      final pagination = Pagination(
        startDate: nextDate,
        endDate: finalDate,
        thumbs: false,
      );

      final response = await _repository.getImages(pagination);

      finalDate = nextDate;

      return [...response, ...?images];
    } catch (e, s) {
      if (e is BaseException) rethrow;

      errorService.recordError(
        e,
        stackTrace: s,
        reason: 'ApodImagesUsecase',
      );

      throw UsecaseException(e.toString());
    }
  }

  DateTime nextFinalDate(DateTime initial, {int interval = 1}) {
    return initial.subtract(Duration(days: interval));
  }
}
