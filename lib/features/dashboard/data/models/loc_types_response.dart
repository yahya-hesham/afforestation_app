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
}
