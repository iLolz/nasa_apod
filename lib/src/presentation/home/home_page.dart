import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection_container.dart';
import '../home_cubit.dart';
import 'home_state.dart';
import 'widgets/custom_error.dart';
import 'widgets/loaded/loaded_state_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<HomeCubit>(
          create: (context) => sl<HomeCubit>()..getImages(),
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
