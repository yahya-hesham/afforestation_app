class DropdownItemModel {
  final int id;
  final String name;

  DropdownItemModel({required this.id, required this.name});

  factory DropdownItemModel.fromJson(Map<String, dynamic> json) {
    return DropdownItemModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItemModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}
