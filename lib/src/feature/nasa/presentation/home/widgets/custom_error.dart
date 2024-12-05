import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_cubit.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Houve um problema ao carregar as imagens',
          ),
          ElevatedButton(
            child: const Text('Tentar novamente'),
            onPressed: () {
              context.read<HomeCubit>().getImages();
            },
          ),
        ],
      ),
    );
  }
}
