class LocTypesResponse {
  int? id;
  String? locationType;

  LocTypesResponse({this.id, this.locationType});

  factory LocTypesResponse.fromJson(Map<String, dynamic> json) {
    return LocTypesResponse(
      id: json['id'] as int?,
      locationType: json['locationType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'locationType': locationType};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocTypesResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
