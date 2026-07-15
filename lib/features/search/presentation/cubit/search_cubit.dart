import 'package:afforestation_app/features/search/data/models/dropdown_item_model.dart';
import 'package:afforestation_app/features/search/data/models/search_request_model.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/data/models/update_record_model.dart';
import 'package:afforestation_app/features/search/data/repo/search_repo.dart';
import 'package:afforestation_app/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  DateTime? fromDate;
  DateTime? toDate;
  int? selectedUserId;
  int? selectedLocationId;
  int? selectedTreeId;

  /// Holds all results returned from the API (no server-side pagination).
  List<SearchResultModel> _allResults = [];

  List<SearchResultModel> get allResults => _allResults;

  /// Holds the loaded dropdown data
  List<DropdownItemModel> users = [];
  List<DropdownItemModel> locations = [];
  List<DropdownItemModel> treeNames = [];

  /// Holds the 30-day summary data
  int summaryTotalByPlantName = 0;
  int summaryTotalByPlantType = 0;
  int summaryDistinctPlantNames = 0;
  int summaryDistinctPlantTypes = 0;
  bool isSummaryLoaded = false;
  bool areDropdownsLoaded = false;

  /// Fetch all dropdown data (users, locations, treeNames) from API
  Future<void> loadDropdowns() async {
    emit(DropdownsLoading());
    try {
      final results = await Future.wait([
        SearchRepo.fetchUsers(),
        SearchRepo.fetchLocations(),
        SearchRepo.fetchTreeNames(),
      ]);

      users = results[0];
      locations = results[1];
      treeNames = results[2];
      areDropdownsLoaded = true;

      emit(DropdownsLoaded(
        users: users,
        locations: locations,
        treeNames: treeNames,
      ));
    } catch (e) {
      emit(DropdownsError(e.toString()));
    }
  }

  /// Fetch last 30 days data from the search API and compute summary
  Future<void> loadLast30DaysSummary() async {
    emit(SummaryLoading());
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final request = SearchRequestModel(
        fromDate: thirtyDaysAgo,
        toDate: now,
      );

      final results = await SearchRepo.search(request: request);

      // Compute summary stats
      summaryTotalByPlantName = results.fold<int>(0, (sum, item) => sum + item.number);

      // Count distinct plant names
      final plantNameSet = results.map((e) => e.treeName).whereType<String>().toSet();
      summaryDistinctPlantNames = plantNameSet.length;

      // Count distinct plant types
      final plantTypeSet = results.map((e) => e.treeTypeName).whereType<String>().toSet();
      summaryDistinctPlantTypes = plantTypeSet.length;

      // Total by plant type (same total, just a different grouping perspective)
      summaryTotalByPlantType = summaryTotalByPlantName;

      isSummaryLoaded = true;

      emit(SummaryLoaded(
        totalByPlantName: summaryTotalByPlantName,
        totalByPlantType: summaryTotalByPlantType,
        distinctPlantNames: summaryDistinctPlantNames,
        distinctPlantTypes: summaryDistinctPlantTypes,
      ));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }

  Future<void> search() async {
    emit(SearchLoading());
    try {
      final request = SearchRequestModel(
        fromDate: fromDate,
        toDate: toDate,
        selectedUserId: selectedUserId,
        selectedLocationId: selectedLocationId,
        selectedTreeId: selectedTreeId,
      );

      _allResults = await SearchRepo.search(request: request);
      emit(SearchSuccess(_allResults));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> deleteRecord(int id) async {
    emit(SearchLoading());
    try {
      await SearchRepo.deleteRecord(id);
      // Remove the deleted item from local list and re-emit success
      _allResults.removeWhere((item) => item.id == id);
      emit(SearchSuccess(List.from(_allResults)));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> updateRecord(UpdateRecordModel data) async {
    emit(SearchLoading());
    try {
      await SearchRepo.updateRecord(id: data.id, data: data);
      // Re-fetch to get updated data from backend
      await search();
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
