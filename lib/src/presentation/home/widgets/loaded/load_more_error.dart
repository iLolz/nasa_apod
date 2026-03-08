import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_cubit.dart';
import '../../home_state.dart';
import '../error_panel.dart';

class FailedToLoadMore extends StatelessWidget {
  const FailedToLoadMore({super.key});

  @override
  Widget build(BuildContext context) {
    final error = context.select<HomeCubit, HomeError?>(
      (cubit) => cubit.state.error,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ErrorPanel(
        compact: true,
        title: 'Falha ao carregar mais itens',
        message: error?.message ?? 'Erro ao carregar próximas imagens',
        buttonLabel: 'Tentar novamente',
        onPressed: () {
          context.read<HomeCubit>().loadMoreImages();
        },
      ),
    );
  }
}
