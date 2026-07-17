  class PlantNamesResponse {
    int? id;
    String? name;
    String? type;
    int? typeId;
    String? scientificName;

    PlantNamesResponse({
      this.id,
      this.name,
      this.type,
      this.typeId,
      this.scientificName,
    });

    factory PlantNamesResponse.fromJson(Map<String, dynamic> json) {
      return PlantNamesResponse(
        id: json['id'] as int?,
        name: json['name'] as String?,
        type: json['type'] as String?,
        typeId: json['typeId'] as int?,
        scientificName: json['scientificName'] as String?,
      );
    }

    Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'type': type,
      'typeId': typeId,
      'scientificName': scientificName,
    };
  }
