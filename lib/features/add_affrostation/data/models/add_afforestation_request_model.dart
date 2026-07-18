class AddAfforestationRequestModel {
  final DateTime dateOfPlanted;
  final int treeTypeId;
  final int treeNameId;
  final int locationTypeId;
  final int locationId;
  final int number;

  AddAfforestationRequestModel({
    required this.dateOfPlanted,
    required this.treeTypeId,
    required this.treeNameId,
    required this.locationTypeId,
    required this.locationId,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    final formattedDate =
        '${dateOfPlanted.year}-${dateOfPlanted.month.toString().padLeft(2, '0')}-${dateOfPlanted.day.toString().padLeft(2, '0')}T00:00:00';
    return {
      'dateOfPlanted': formattedDate,
      'treeTypeId': treeTypeId,
      'treeNameId': treeNameId,
      'locationTypeId': locationTypeId,
      'locationId': locationId,
      'number': number,
    };
  }
}
