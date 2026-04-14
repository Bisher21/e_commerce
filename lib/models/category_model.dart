class CategoryModel {
  final String id;
  final String title;
  final int productsCount;
  final String imgUrl;

  CategoryModel({
    required this.id,
    required this.title,
    required this.productsCount,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'productsCount': productsCount,
      'imgUrl': imgUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      productsCount: map['productsCount'] ?? 0,
      imgUrl: map['imgUrl'] ?? '',
    );
  }
}

final List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: 'cat_001',
    title: 'New Arrivals',
    productsCount: 124,
    // A stylish clothing boutique rack
    imgUrl:
        'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?auto=format&fit=crop&w=800&q=80',
  ),
  CategoryModel(
    id: 'cat_002',
    title: 'Shoes',
    productsCount: 85,
    // A classic, clean sneaker shot
    imgUrl:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=400&q=80',
  ),
  CategoryModel(
    id: 'cat_003',
    title: 'Clothes',
    productsCount: 340,
    // Neatly folded premium shirts
    imgUrl:
        'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=400&q=80',
  ),
  CategoryModel(
    id: 'cat_004',
    title: 'Electronics',
    productsCount: 65,
    // Modern tech gadgets and accessories
    imgUrl:
        'https://images.unsplash.com/photo-1526406915894-7bcd65f60845?auto=format&fit=crop&w=400&q=80',
  ),
  CategoryModel(
    id: 'cat_005',
    title: 'Bags',
    productsCount: 42,
    // A premium leather backpack/bag
    imgUrl:
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=800&q=80',
  ),
];
