import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';

class LocationManagementState {}

class LocationManagementInitial extends LocationManagementState {}

class LocationManagementLoading extends LocationManagementState {}

class LocationManagementSuccess extends LocationManagementState {
  final List<LocTypesResponse> categories;
  final LocTypesResponse selectedCategory;
  // BUG FIX: this was `List<LocTypesResponse>`, so it could never actually
  // hold the fetched location names - it's a list of places, not types.
  final List<LocNamesResponse> locations;

  // Total across ALL types (not just the selected one), for the summary
  // card at the bottom of the screen.
  final int totalLocationsCount;

  // True while an add/edit/delete/select-category request is in flight, so
  // the UI can show a subtle loader without replacing the whole list.
  final bool isMutating;

  LocationManagementSuccess({
    required this.categories,
    required this.selectedCategory,
    required this.locations,
    this.totalLocationsCount = 0,
    this.isMutating = false,
  });

  LocationManagementSuccess copyWith({
    List<LocTypesResponse>? categories,
    LocTypesResponse? selectedCategory,
    List<LocNamesResponse>? locations,
    int? totalLocationsCount,
    bool? isMutating,
  }) {
    return LocationManagementSuccess(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      locations: locations ?? this.locations,
      totalLocationsCount: totalLocationsCount ?? this.totalLocationsCount,
      isMutating: isMutating ?? this.isMutating,
    );
  }
}

class LocationManagementFailure extends LocationManagementState {
  final String errorMessage;
  LocationManagementFailure(this.errorMessage);
}