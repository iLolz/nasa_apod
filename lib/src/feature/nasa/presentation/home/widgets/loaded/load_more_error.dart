import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home_cubit.dart';

class FailedToLoadMore extends StatelessWidget {
  const FailedToLoadMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Erro ao carregar próximas imagens',
        ),
        ElevatedButton(
          child: const Text('Tentar novamente'),
          onPressed: () {
            context.read<HomeCubit>().loadMoreSales();
          },
        ),
      ],
    );
  }
}
