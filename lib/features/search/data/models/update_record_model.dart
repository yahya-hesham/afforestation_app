class UpdateRecordModel {
  final int id;
  final DateTime? dateOfPlanted;
  final int? treeTypeId;
  final int? treeNameId;
  final int? locationId;
  final int? locationTypeId;
  final int? number;

  UpdateRecordModel({
    required this.id,
    this.dateOfPlanted,
    this.treeTypeId,
    this.treeNameId,
    this.locationId,
    this.locationTypeId,
    this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (dateOfPlanted != null)
        'dateOfPlanted':
            '${dateOfPlanted!.year}-${dateOfPlanted!.month.toString().padLeft(2, '0')}-${dateOfPlanted!.day.toString().padLeft(2, '0')}',
      if (treeTypeId != null) 'treeTypeId': treeTypeId,
      if (treeNameId != null) 'treeNameId': treeNameId,
      if (locationId != null) 'locationId': locationId,
      if (locationTypeId != null) 'locationTypeId': locationTypeId,
      if (number != null) 'number': number,
    };
  }
}
