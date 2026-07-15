import 'package:afforestation_app/features/search/data/models/paginated_result_model.dart';

class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final PaginatedResultModel result;

  SearchSuccess(this.result);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
