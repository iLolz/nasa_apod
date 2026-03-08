import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/core/di/injection_container.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/data_source/images_local_data_source.dart';
import 'package:nasa_apod/src/data/repository/images_repository.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

void main() {
  setUp(() async {
    await sl.reset();
  });

  tearDown(() async {
    await sl.reset();
  });

  test('init registers application dependencies', () async {
    await init();

    expect(sl.isRegistered<Dio>(), isTrue);
    expect(sl.isRegistered<ImageDataSource>(), isTrue);
    expect(sl.isRegistered<ImagesLocalDataSource>(), isTrue);
    expect(sl.isRegistered<ImagesRepository>(), isTrue);
    expect(sl.isRegistered<ApodImagesUsecase>(), isTrue);
    expect(sl.isRegistered<HomeCubit>(), isTrue);

    expect(sl<Dio>(), isA<Dio>());
    expect(sl<ImageDataSource>(), isA<ImageDataSource>());
    expect(sl<ImagesLocalDataSource>(), isA<ImagesLocalDataSource>());
    expect(sl<ImagesRepository>(), isA<ImagesRepository>());
    expect(sl<ApodImagesUsecase>(), isA<ApodImagesUsecase>());
    expect(sl<HomeCubit>(), isA<HomeCubit>());
  });

  test('HomeCubit is registered as a factory', () async {
    await init();

    final first = sl<HomeCubit>();
    final second = sl<HomeCubit>();

    expect(identical(first, second), isFalse);

    await first.close();
    await second.close();
  });
}
