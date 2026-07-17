class LocationResponse {
  String? name;
  int? locationTypeId;
  String? locationType;

  LocationResponse({this.name, this.locationTypeId, this.locationType});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      name: json['name'] as String?,
      locationTypeId: json['locationTypeId'] as int?,
      locationType: json['locationType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'locationTypeId': locationTypeId,
    'locationType': locationType,
  };
}
