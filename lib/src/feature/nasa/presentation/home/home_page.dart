import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../home_cubit.dart';
import 'home_bindings.dart';
import 'home_state.dart';
import 'widgets/custom_error.dart';
import 'widgets/loaded/loaded_state_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    HomeBindings.init();
    super.initState();
  }

  @override
  void dispose() {
    HomeBindings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => GetIt.I.get<HomeCubit>(),
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
