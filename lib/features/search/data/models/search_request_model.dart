class SearchRequestModel {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? selectedUserId;
  final int? selectedLocationId;
  final int? selectedTreeId;

  SearchRequestModel({
    this.fromDate,
    this.toDate,
    this.selectedUserId,
    this.selectedLocationId,
    this.selectedTreeId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fromDate != null)
        'fromDate':
            '${fromDate!.year}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}',
      if (toDate != null)
        'toDate':
            '${toDate!.year}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}',
      if (selectedUserId != null) 'selectedUserId': selectedUserId,
      if (selectedLocationId != null) 'selectedLocationId': selectedLocationId,
      if (selectedTreeId != null) 'selectedTreeId': selectedTreeId,
    };
  }
}
