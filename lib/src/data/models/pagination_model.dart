import '../../core/utils/formatters.dart';
import '../../domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required super.startDate,
    required super.endDate,
    required super.thumbs,
  });

  factory PaginationModel.fromPagination(Pagination pagination) {
    return PaginationModel(
      startDate: pagination.startDate,
      endDate: pagination.endDate,
      thumbs: pagination.thumbs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_date': Formatters.toYMD(startDate),
      'end_date': Formatters.toYMD(endDate),
      'thumbs': thumbs,
    };
  }
}
