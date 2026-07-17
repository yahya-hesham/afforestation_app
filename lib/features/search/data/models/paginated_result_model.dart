import 'package:afforestation_app/features/search/data/models/search_result_model.dart';

class PaginatedResultModel {
  final List<SearchResultModel> items;
  final int totalCount;
  final int page;
  final int pageSize;

  PaginatedResultModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory PaginatedResultModel.fromJson(Map<String, dynamic> json) {
    return PaginatedResultModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => SearchResultModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }
}
