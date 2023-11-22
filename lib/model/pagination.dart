import 'dart:math';

class Pagination {
  Pagination(this.page, this.itemsPerPage, this.totalItems);

  final int page;
  final int itemsPerPage;
  final int totalItems;

  int get totalPages => max(1, (totalItems / itemsPerPage).ceil());

  bool get hasNext => page < totalPages;

  bool get hasPrev => page > 1;
}
