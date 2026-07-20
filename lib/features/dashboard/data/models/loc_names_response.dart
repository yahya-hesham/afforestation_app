class LocNamesResponse {
  int? id;
  String? name;

  int? locationTypeId;

  LocNamesResponse({this.id, this.name, this.locationTypeId});

  factory LocNamesResponse.fromJson(Map<String, dynamic> json) {
    return LocNamesResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      locationTypeId: json['locationTypeId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'locationTypeId': locationTypeId,
  };
}