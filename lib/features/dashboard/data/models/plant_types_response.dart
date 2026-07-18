class PlantTypesResponse {
  int? id;
  String? type;

  PlantTypesResponse({this.id, this.type});

  factory PlantTypesResponse.fromJson(Map<String, dynamic> json) {
    return PlantTypesResponse(
      id: json['id'] as int?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'type': type};
}
