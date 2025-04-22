class Store {
  final String storeName;
  final double lat;
  final double lng;
  final String storeType;
  final double rating;
  final bool isOpen;

  Store({
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
      storeName: json['store_name'] as String,
      lat: toDouble(json['lat']),
      lng: toDouble(json['lng']),
      storeType: json['store_type'] as String,
      rating: toDouble(json['rating']),
      isOpen: json['is_open'] as bool,
    );
  }
}
