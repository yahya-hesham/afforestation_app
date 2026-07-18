class PlantTypesResponse {
  int? id;
  String? type;

  PlantTypesResponse({this.id, this.type});

  factory PlantTypesResponse.fromJson(dynamic json) {
    if (json is String) {
      return PlantTypesResponse(type: json);
    }
    if (json is Map<String, dynamic>) {
      final parsedId = json['id'] is int
          ? json['id'] as int?
          : (json['typeId'] is int
              ? json['typeId'] as int?
              : (json['treeTypeId'] is int
                  ? json['treeTypeId'] as int?
                  : int.tryParse(json['id']?.toString() ?? '')));

      final parsedType = json['type']?.toString() ??
          json['typeName']?.toString() ??
          json['treeTypeName']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString();

      return PlantTypesResponse(
        id: parsedId,
        type: parsedType,
      );
    }
    return PlantTypesResponse();
  }

  Map<String, dynamic> toJson() => {'id': id, 'type': type};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantTypesResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
