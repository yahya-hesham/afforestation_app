class LocationTypeModel {
  int? id;
  String? locationType;
  String? createdAt;
  int? locationsCount;
  double? progress;

  LocationTypeModel({
    this.id,
    this.locationType,
    this.createdAt,
    this.locationsCount,
    this.progress,
  });

  factory LocationTypeModel.fromJson(Map<String, dynamic> json) {
    return LocationTypeModel(
      id: json['id'] as int?,
      locationType: json['locationType'] as String?,
      createdAt: json['createdAt'] as String?,
      locationsCount: json['locationsCount'] as int?,
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'locationType': locationType,
    'createdAt': createdAt,
    'locationsCount': locationsCount,
    'progress': progress,
  };
}
