class HomeCarouselItem {
  final String id;
  final String imgUrl;

  HomeCarouselItem({
    required this.id,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
    };
  }

  factory HomeCarouselItem.fromMap(Map<String, dynamic> map) {
    return HomeCarouselItem(
      id: map['id'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
    );
  }
}

List<HomeCarouselItem> dummyHomeCarousalItems = [
  HomeCarouselItem(
    id: 'carousel_001',
    // Image of shopping bags with a prominent "%" discount sign
    imgUrl:
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=1000&q=80',
  ),
  HomeCarouselItem(
    id: 'carousel_002',
    // Image of a woman holding shopping bags (Fashion Promo)
    imgUrl:
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1000&q=80',
  ),
  HomeCarouselItem(
    id: 'carousel_003',
    // High-end workspace setup (Electronics & Tech Promo)
    imgUrl:
        'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1000&q=80',
  ),
  HomeCarouselItem(
    id: 'carousel_004',
    // Stylish sneakers (Shoes & Activewear Promo)
    imgUrl:
        'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=1000&q=80',
  ),
];
