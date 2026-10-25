class AddAfforestationRequestModel {
  final DateTime dateOfPlanted;
  final int treeTypeId;
  final int treeNameId;
  final int locationTypeId;
  final int locationNameId;
  final int userId;
  final int number;

  AddAfforestationRequestModel({
    required this.dateOfPlanted,
    required this.treeTypeId,
    required this.treeNameId,
    required this.locationTypeId,
    required this.locationNameId,
    required this.userId,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    // Format as pure 'YYYY-MM-DD' without time or 'T' separator
    final formattedDate =
        '${dateOfPlanted.year}-${dateOfPlanted.month.toString().padLeft(2, '0')}-${dateOfPlanted.day.toString().padLeft(2, '0')}';

    return {
      'dateOfPlanted': formattedDate,
      'treeTypeId': treeTypeId,
      'treeNameId': treeNameId,
      'locationTypeId': locationTypeId,
      'locationNameId': locationNameId,
      'userId': userId,
      'number': number,
    };
  }
}
