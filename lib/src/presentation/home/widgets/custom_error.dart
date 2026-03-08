import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_cubit.dart';
import '../home_state.dart';
import 'error_panel.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key});

  @override
  Widget build(BuildContext context) {
    final error = context.select<HomeCubit, HomeError?>(
      (cubit) => cubit.state.error,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorPanel(
            title: 'Falha ao carregar a galeria',
            message:
                error?.message ?? 'Houve um problema ao carregar as imagens',
            buttonLabel: 'Tentar novamente',
            onPressed: () {
              context.read<HomeCubit>().getImages();
            },
          ),
        ),
      ),
    );
  }
}
