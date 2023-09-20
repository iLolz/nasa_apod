class Pagination {
  final DateTime startDate;
  final DateTime endDate;
  final bool thumbs;

  const Pagination({
    required this.startDate,
    required this.endDate,
    required this.thumbs,
  });

  factory Pagination.empty() {
    return Pagination(
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now(),
      thumbs: true,
    );
  }

  Pagination next() {
    return Pagination(
      startDate: startDate.subtract(const Duration(days: 10)),
      endDate: startDate,
      thumbs: thumbs,
    );
  }
}
