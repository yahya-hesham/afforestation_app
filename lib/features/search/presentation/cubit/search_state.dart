import 'package:afforestation_app/features/search/data/models/search_result_model.dart';

class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<SearchResultModel> results;

  SearchSuccess(this.results);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

class RecordDeleted extends SearchState {}

class RecordUpdated extends SearchState {}
