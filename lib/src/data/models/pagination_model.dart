import '../../domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required super.startDate,
    required super.endDate,
    required super.thumbs,
  });

  Map<String, dynamic> toMap() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'thumbs': thumbs,
    };
  }
}
