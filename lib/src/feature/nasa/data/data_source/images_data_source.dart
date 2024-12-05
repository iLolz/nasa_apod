import 'package:dio/dio.dart';

import '../../../../core/services/error_service.dart';
import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';

abstract class ImageDataSource {
  final Dio client;
  final ErrorService errorService;

  const ImageDataSource(this.client, this.errorService);

  Future<List<ApodImageModel>> getImages(PaginationModel p);
}
