import 'package:afforestation_app/features/search/data/models/dropdown_item_model.dart';
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

// --- Dropdown states ---

class DropdownsLoading extends SearchState {}

class DropdownsLoaded extends SearchState {
  final List<DropdownItemModel> users;
  final List<DropdownItemModel> locations;
  final List<DropdownItemModel> treeNames;

  DropdownsLoaded({
    required this.users,
    required this.locations,
    required this.treeNames,
  });
}

class DropdownsError extends SearchState {
  final String message;

  DropdownsError(this.message);
}

// --- 30-day summary states ---

class SummaryLoading extends SearchState {}

class SummaryLoaded extends SearchState {
  final int totalByPlantName;
  final int totalByPlantType;
  final int distinctPlantNames;
  final int distinctPlantTypes;

  SummaryLoaded({
    required this.totalByPlantName,
    required this.totalByPlantType,
    required this.distinctPlantNames,
    required this.distinctPlantTypes,
  });
}

class SummaryError extends SearchState {
  final String message;

  SummaryError(this.message);
}
