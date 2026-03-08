import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../core/utils/exceptions.dart';
import '../../core/utils/formatters.dart';
import '../models/apod_image_model.dart';
import '../models/pagination_model.dart';
import 'images_local_data_source.dart';

typedef DirectoryProvider = Future<Directory> Function();

class ImagesLocalDataSourceImpl extends ImagesLocalDataSource {
  const ImagesLocalDataSourceImpl({
    DirectoryProvider directoryProvider = getApplicationSupportDirectory,
  }) : _directoryProvider = directoryProvider;

  final DirectoryProvider _directoryProvider;

  @override
  Future<List<ApodImageModel>?> getImages(PaginationModel pagination) async {
    try {
      final file = await _cacheFile(pagination);

      if (!file.existsSync()) {
        return null;
      }

      final content = await file.readAsString();
      final decoded = jsonDecode(content) as List<dynamic>;

      return decoded
          .map(
            (item) => ApodImageModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    } catch (e) {
      if (e is BaseException) {
        rethrow;
      }

      throw DataSourceException(e.toString());
    }
  }

  @override
  Future<void> saveImages(
    PaginationModel pagination,
    List<ApodImageModel> images,
  ) async {
    try {
      final file = await _cacheFile(pagination);
      await file.parent.create(recursive: true);
      await file.writeAsString(
        jsonEncode(
          images.map((image) => image.toMap()).toList(growable: false),
        ),
      );
    } catch (e) {
      if (e is BaseException) {
        rethrow;
      }

      throw DataSourceException(e.toString());
    }
  }

  Future<File> _cacheFile(PaginationModel pagination) async {
    final directory = await _directoryProvider();
    final cacheDirectory = Directory('${directory.path}/apod_cache');
    final startDate = Formatters.toYMD(pagination.startDate);
    final endDate = Formatters.toYMD(pagination.endDate);

    final fileName = '${startDate}_${endDate}_${pagination.thumbs}.json';

    return File('${cacheDirectory.path}/$fileName');
  }
}
