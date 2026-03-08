import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/presentation/details/details_page.dart';
import 'package:nasa_apod/src/presentation/home/home_state.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/image_card.dart';
import 'package:nasa_apod/src/presentation/home/widgets/loaded/loaded_state_widget.dart';
import 'package:nasa_apod/src/presentation/home_cubit.dart';

import '../../../test_home_cubit.dart';

void main() {
  group('Loaded widgets', () {
    testWidgets('LoadedStateWidget renders images and state-specific footers',
        (tester) async {
      final cubit = TestHomeCubit(
        initialState: HomeState(
          status: HomeStatus.loaded,
          pagination: testPagination(),
          images: [testImage(title: 'Galaxy')],
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
        HomeState(
          status: HomeStatus.loadingMore,
          pagination: testPagination(),
          images: [testImage(title: 'Galaxy')],
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      cubit.setState(
        HomeState(
          status: HomeStatus.loadMoreError,
          pagination: testPagination(),
          images: [testImage(title: 'Galaxy')],
        ),
      );
      await tester.pump();

      expect(find.text('Erro ao carregar próximas imagens'), findsOneWidget);
    });

    testWidgets('ImageCard renders media metadata and navigates to details',
        (tester) async {
      final image = testImage(title: 'Nebula');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageCard(image: image),
          ),
        ),
      );

      expect(find.byType(ImageCard), findsOneWidget);
      expect(find.text('Nebula'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('20/01/2024'), findsOneWidget);
      expect(find.text('Image'), findsOneWidget);

      await tester.tap(find.byType(ImageCard));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(DetailsPage), findsOneWidget);
      expect(find.text('NASA APOD'), findsWidgets);
      expect(find.text('20/01/2024'), findsWidgets);

      await tester.scrollUntilVisible(
        find.text('About this capture'),
        200,
        scrollable: find.byType(Scrollable).last,
      );

      expect(find.text('About this capture'), findsOneWidget);
    });
  });
}
