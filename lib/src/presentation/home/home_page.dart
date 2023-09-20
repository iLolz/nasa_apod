import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nasa_apod/src/core/services/dio_service.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source.dart';
import 'package:nasa_apod/src/data/data_source/images_data_source_impl.dart';
import 'package:nasa_apod/src/data/repository/images_repository.dart';
import 'package:nasa_apod/src/data/repository/images_repository_impl.dart';
import 'package:nasa_apod/src/domain/usecase/apod_images_usecase.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home/widgets/custom_error.dart';

import '../home_cubit.dart';
import 'widgets/loaded/loaded_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final getIt = GetIt.I;

    getIt.registerLazySingleton<Dio>(
      () => DioService().setup(),
    );
    getIt.registerFactory<ImageDataSource>(
      () => ImagesDataSourceImpl(
        getIt.get<Dio>(),
      ),
    );
    getIt.registerFactory<ImagesRepository>(
      () => ImagesRepositoryImpl(
        getIt.get<ImageDataSource>(),
      ),
    );
    getIt.registerFactory<ApodImagesUsecase>(
      () => ApodImagesUsecase(
        getIt.get<ImagesRepository>(),
      ),
    );
    getIt.registerSingleton<HomeCubit>(
      HomeCubit(
        getIt.get<ApodImagesUsecase>(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<HomeCubit>(
          create: (context) => GetIt.I.get<HomeCubit>()..getImages(),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, HomeState state) {
              return state.whenBuild(
                loading: const Center(child: CircularProgressIndicator()),
                loaded: const LoadedStateWidget(),
                error: const CustomError(),
              );
            },
          ),
        ),
      ),
    );
  }
}
