class Store {
  final int id;  // Change id to int
  final String storeName;
  final double lat;
  final double lng;
  final String storeType;
  final double rating;
  final bool isOpen;

  Store({
    required this.id,
    required this.storeName,
    required this.lat,
    required this.lng,
    required this.storeType,
    required this.rating,
    required this.isOpen,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value is int) return value.toDouble();
      return value as double;
    }

    return Store(
      id: json['id'] as int,  // Expect id to be an int
      storeName: json['store_name'] as String,
      lat: toDouble(json['lat']),
      lng: toDouble(json['lng']),
      storeType: json['store_type'] as String,
      rating: toDouble(json['rating']),
      isOpen: json['is_open'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,  // id is now an int
    'store_name': storeName,
    'lat': lat,
    'lng': lng,
    'store_type': storeType,
    'rating': rating,
    'is_open': isOpen,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Store && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
