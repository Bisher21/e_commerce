enum ProductSize {
  S,
  M,
  L,
  XL,
}

class ProductItemModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;
  final double price;
  final bool isFavorite;
  final double averageRate;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
    this.description =
        "Lorem dummy data and i'm only doing this to fill the description by default Lorem dummy data and i'm only doing this to fill the description by default Lorem dummy data and i'm only doing this to fill the description by default Lorem dummy data and i'm only doing this to fill the description by default Lorem dummy data and i'm only doing this to fill the description by default.",
    this.averageRate = 4.8,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    String? description,
    double? price,
    bool? isFavorite,
    double? averageRate,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      averageRate: averageRate ?? this.averageRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      //'isFavorite': isFavorite,
      'averageRate': averageRate,
    };
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> map) {
    return ProductItemModel(
      id: map['id']?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
     // isFavorite: map['isFavorite'] ?? false,
      averageRate: (map['averageRate'] ?? 4.8).toDouble(),
    );
  }
}

List<ProductItemModel> dummyProducts = [
  ProductItemModel(
    id: 'prod_001',
    name: 'Running Sport Shoe',
    category: 'Shoes',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2589/2589903.png',
    price: 89.99,
  ),
  ProductItemModel(
    id: 'prod_002',
    name: 'Basic Cotton T-Shirt',
    category: 'Clothing',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/892/892458.png',
    price: 24.99,
  ),
  ProductItemModel(
    id: 'prod_003',
    name: 'Premium Over-Ear Headphones',
    category: 'Audio',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/airpods-max-select-silver-202011?wid=400&hei=400&fmt=png-alpha',
    price: 549.00,
  ),
  ProductItemModel(
    id: 'prod_004',
    name: 'Pro Wireless Earbuds',
    category: 'Audio',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=400&hei=400&fmt=png-alpha',
    price: 249.00,
  ),
  ProductItemModel(
    id: 'prod_005',
    name: 'Lightweight Laptop',
    category: 'Computers',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-air-midnight-select-20220606?wid=400&hei=400&fmt=png-alpha',
    price: 1199.00,
  ),
  ProductItemModel(
    id: 'prod_006',
    name: 'Leather Hand Bag',
    category: 'Bags',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2331/2331970.png',
    price: 59.99,
  ),
  ProductItemModel(
    id: 'prod_007',
    name: 'Mini Smart Speaker',
    category: 'Audio',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/homepod-mini-select-yellow-202110?wid=400&hei=400&fmt=png-alpha',
    price: 99.00,
  ),
  ProductItemModel(
    id: 'prod_008',
    name: 'Smart Tracking Tag',
    category: 'Accessories',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/airtag-single-select-202104?wid=400&hei=400&fmt=png-alpha',
    price: 29.00,
  ),
  ProductItemModel(
    id: 'prod_009',
    name: 'Ergonomic Wireless Mouse',
    category: 'Accessories',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MMMQ3?wid=400&hei=400&fmt=png-alpha',
    price: 99.00,
  ),
  ProductItemModel(
    id: 'prod_010',
    name: 'Slim Wireless Keyboard',
    category: 'Accessories',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MK2A3?wid=400&hei=400&fmt=png-alpha',
    price: 149.00,
  ),
  ProductItemModel(
    id: 'prod_011',
    name: '4K Media Streamer',
    category: 'Electronics',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/apple-tv-4k-hero-select-202210?wid=400&hei=400&fmt=png-alpha',
    price: 129.00,
  ),
  ProductItemModel(
    id: 'prod_012',
    name: 'Magnetic Wireless Charger',
    category: 'Accessories',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MHXH3?wid=400&hei=400&fmt=png-alpha',
    price: 39.00,
  ),
  ProductItemModel(
    id: 'prod_013',
    name: 'Iphone 16 pro',
    category: 'Audio',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQUF3?wid=400&hei=400&fmt=png-alpha',
    price: 349.00,
  ),
  ProductItemModel(
    id: 'prod_014',
    name: 'Digital Stylus Pen',
    category: 'Accessories',
    imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MU8F2?wid=400&hei=400&fmt=png-alpha',
    price: 129.00,
  ),
];
