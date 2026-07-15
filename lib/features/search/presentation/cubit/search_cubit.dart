import 'package:afforestation_app/features/search/data/models/search_request_model.dart';
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

  Future<void> search({int page = 1, int pageSize = 10}) async {
    emit(SearchLoading());
    try {
      final request = SearchRequestModel(
        fromDate: fromDate,
        toDate: toDate,
        selectedUserId: selectedUserId,
        selectedLocationId: selectedLocationId,
        selectedTreeId: selectedTreeId,
      );

      final result = await SearchRepo.search(
        request: request,
        page: page,
        pageSize: pageSize,
      );

      emit(SearchSuccess(result));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
