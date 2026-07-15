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
