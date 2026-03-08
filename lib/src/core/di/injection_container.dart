import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/data_source/images_data_source.dart';
import '../../data/data_source/images_data_source_impl.dart';
import '../../data/data_source/images_local_data_source.dart';
import '../../data/data_source/images_local_data_source_impl.dart';
import '../../data/repository/images_repository.dart';
import '../../data/repository/images_repository_impl.dart';
import '../../domain/usecase/apod_images_usecase.dart';
import '../../presentation/home_cubit.dart';
import '../services/dio_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ═══════════════════════════════════════
  // CORE
  // ═══════════════════════════════════════
  sl.registerLazySingleton<Dio>(() => DioService().setup());

  // ═══════════════════════════════════════
  // DATA SOURCES
  // ═══════════════════════════════════════
  sl.registerLazySingleton<ImageDataSource>(
    () => ImagesDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ImagesLocalDataSource>(
    ImagesLocalDataSourceImpl.new,
  );

  // ═══════════════════════════════════════
  // REPOSITORIES
  // ═══════════════════════════════════════
  sl.registerLazySingleton<ImagesRepository>(
    () => ImagesRepositoryImpl(sl(), sl()),
  );

  // ═══════════════════════════════════════
  // USE CASES
  // ═══════════════════════════════════════
  sl.registerLazySingleton<ApodImagesUsecase>(
    () => ApodImagesUsecase(sl()),
  );

  // ═══════════════════════════════════════
  // CUBITS / BLOCS
  // ═══════════════════════════════════════
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(sl()),
  );
}
