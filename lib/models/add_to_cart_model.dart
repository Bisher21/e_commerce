import 'package:e_commerce/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final int quantity;
  final ProductSize size;
  final ProductItemModel product;

  AddToCartModel({
    required this.id,
    required this.quantity,
    required this.size,
    required this.product,
  });

  double get totalPrice => product.price * quantity;

  AddToCartModel copyWith({
    String? id,
    int? quantity,
    ProductSize? size,
    ProductItemModel? product,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'size': size.name,
      'product': product.toMap(),
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'] ?? '',
      quantity: map['quantity'] ?? 1,
      size: ProductSize.values.byName(map['size']),
      product: ProductItemModel.fromMap(map['product']),
    );
  }
}

final List<AddToCartModel> dummyCarts = [];
