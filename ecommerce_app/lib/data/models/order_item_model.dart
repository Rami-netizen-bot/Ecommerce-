import 'product_model.dart';

class OrderItemModel {
  final int id;
  final int quantity;
  final Product? product;

  OrderItemModel({
    required this.id,
    required this.quantity,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }
}