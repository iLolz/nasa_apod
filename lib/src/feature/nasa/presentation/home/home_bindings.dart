import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/error_service.dart';
import '../../data/data_source/images_data_source.dart';
import '../../data/data_source/images_data_source_impl.dart';
import '../../data/repository/images_repository.dart';
import '../../data/repository/images_repository_impl.dart';
import '../../domain/usecase/apod_images_usecase.dart';
import '../home_cubit.dart';

class HomeBindings {
  static void init() {
    final getIt = GetIt.I;

    getIt.registerLazySingleton<ErrorService>(ErrorServiceImpl.new);
    getIt.registerLazySingleton<Dio>(DioService.setup);
    getIt.registerFactory<ImageDataSource>(
      () => ImagesDataSourceImpl(
        getIt.get<Dio>(),
        getIt.get<ErrorService>(),
      ),
    );
    getIt.registerFactory<ImagesRepository>(
      () => ImagesRepositoryImpl(
        getIt.get<ImageDataSource>(),
        getIt.get<ErrorService>(),
      ),
    );
    getIt.registerFactory<ApodImagesUsecase>(
      () => ApodImagesUsecase(
        getIt.get<ImagesRepository>(),
        getIt.get<ErrorService>(),
      ),
    );
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(
        getIt.get<ApodImagesUsecase>(),
      ),
    );
  }

  static void dispose() {
    final getIt = GetIt.I;

    getIt.unregister<Dio>();
    getIt.unregister<ImageDataSource>();
    getIt.unregister<ImagesRepository>();
    getIt.unregister<ApodImagesUsecase>();
    getIt.unregister<HomeCubit>();
  }
}
