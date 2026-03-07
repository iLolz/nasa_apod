import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/presentation/details/details_page.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/image_card.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/images_list.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/loaded_state_widget.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import '../../../test_home_cubit.dart';

void main() {
  group('Loaded widgets', () {
    testWidgets('LoadedStateWidget renders images and state-specific footers',
        (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeStateLoaded(
          testPagination(),
          [testImage(title: 'Galaxy')],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const Scaffold(
              body: LoadedStateWidget(),
            ),
          ),
        ),
      );

      expect(find.text('NASA APOD'), findsOneWidget);
      expect(find.text('Galaxy'), findsOneWidget);

      cubit.setState(
        HomeStateLoadingMore(
          testPagination(),
          [testImage(title: 'Galaxy')],
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      cubit.setState(
        HomeStateLoadingMoreError(
          testPagination(),
          [testImage(title: 'Galaxy')],
        ),
      );
      await tester.pump();

      expect(find.text('Erro ao carregar próximas imagens'), findsOneWidget);
    });

    testWidgets('ImagesList renders cards and navigates to details on tap',
        (tester) async {
      final image = testImage(title: 'Nebula');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImagesList([image]),
          ),
        ),
      );

      expect(find.byType(ImageCard), findsOneWidget);
      expect(find.text('Nebula'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      await tester.tap(find.byType(ImageCard));
      await tester.pumpAndSettle();

      expect(find.byType(DetailsPage), findsOneWidget);
      expect(find.text('Photo shooted on: 20/01/2024'), findsOneWidget);
    });
  });
}
