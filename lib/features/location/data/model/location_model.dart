class LocationModel {
  final String name;
  final int
  locationTypeId; // أو String حسب الـ API بتاعكم بياخد ID ولا اسم النوع
  final String address;
  final double latitude;
  final double longitude;
  final String notes;

  LocationModel({
    required this.name,
    required this.locationTypeId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'locationTypeId': locationTypeId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    };
  }
}
