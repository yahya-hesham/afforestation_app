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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocNamesResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
