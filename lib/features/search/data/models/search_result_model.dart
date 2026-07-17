class SearchResultModel {
  final int id;
  final DateTime dateOfPlanted;
  final String? treeName;
  final int treeNameId;
  final String? scientificName;
  final String? treeTypeName;
  final int treeTypeId;
  final int locationId;
  final int locationTypeId;
  final String? locationTypeName;
  final String? locationName;
  final String? userName;
  final int number;

  SearchResultModel({
    required this.id,
    required this.dateOfPlanted,
    this.treeName,
    required this.treeNameId,
    this.scientificName,
    this.treeTypeName,
    required this.treeTypeId,
    required this.locationId,
    required this.locationTypeId,
    this.locationTypeName,
    this.locationName,
    this.userName,
    required this.number,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? 0,
      dateOfPlanted: DateTime.parse(json['dateOfPlanted']),
      treeName: json['treeName'],
      treeNameId: json['treeNameId'] ?? 0,
      scientificName: json['scientificName'],
      treeTypeName: json['treeTypeName'],
      treeTypeId: json['treeTypeId'] ?? 0,
      locationId: json['locationId'] ?? 0,
      locationTypeId: json['locationTypeId'] ?? 0,
      locationTypeName: json['locationTypeName'],
      locationName: json['locationName'],
      userName: json['userName'],
      number: json['number'] ?? 0,
    );
  }
}
