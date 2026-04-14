class AddressModel {
  final String id;
  final String city;
  final String country;
  final String image;
  final bool isSelected;

  AddressModel({
    required this.id,
    required this.city,
    required this.country,
    // Default location image URL
    this.image =
        'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=400&q=80',
    this.isSelected = false,
  });

  AddressModel copyWith({
    String? id,
    String? city,
    String? country,
    String? image,
    bool? isSelected,
  }) {
    return AddressModel(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      image: image ?? this.image,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'country': country,
      'image': image,
      'isSelected': isSelected,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      image: map['image'] ??
          'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=400&q=80',
      isSelected: map['isSelected'] ?? false,
    );
  }
}

List<AddressModel> dummyAddresses = [
  AddressModel(id: '1', city: 'New York', country: 'USA'),
  AddressModel(id: '2', city: 'London', country: 'UK'),
  AddressModel(id: '3', city: 'Paris', country: 'France'),
  AddressModel(id: '4', city: 'Tokyo', country: 'Japan'),
];
