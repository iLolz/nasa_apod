import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/src/domain/entities/pagination.dart';

void main() {
  group('Pagination', () {
    test('empty creates a 10 day range with thumbs enabled', () {
      final pagination = Pagination.empty();

      expect(pagination.thumbs, isTrue);
      expect(
        pagination.endDate.difference(pagination.startDate).inDays,
        10,
      );
    });

    test('next shifts the window back by 10 days without overlap', () {
      final pagination = Pagination(
        startDate: DateTime(2024, 1, 11),
        endDate: DateTime(2024, 1, 21),
        thumbs: true,
      );

      final nextPage = pagination.next();

      expect(nextPage.startDate, DateTime(2024, 1, 1));
      expect(nextPage.endDate, DateTime(2024, 1, 10));
      expect(nextPage.thumbs, isTrue);
    });
  });
}
