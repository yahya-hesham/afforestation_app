class AddPlantRecordRequest {
  final String dateOfPlanted;
  final int treeTypeId;
  final int treeNameId;
  final int locationTypeId;
  final int locationNameId;
  final int userId;
  final int number;

  AddPlantRecordRequest({
    required this.dateOfPlanted,
    required this.treeTypeId,
    required this.treeNameId,
    required this.locationTypeId,
    required this.locationNameId,
    required this.userId,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      "dateOfPlanted": dateOfPlanted,
      "treeTypeId": treeTypeId,
      "treeNameId": treeNameId,
      "locationTypeId": locationTypeId,
      "locationNameId": locationNameId,
      "userId": userId,
      "number": number,
    };
  }
}