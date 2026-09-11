import 'package:flutter/material.dart';
import 'product_model.dart';

class OrderItemModel {
  final int id;
  final int? productId;
  final int quantity;
  final Product? product;

  OrderItemModel({
    required this.id,
    this.productId,
    required this.quantity,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'], // Safe if null
      quantity: json['quantity'] ?? 1,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}

class OrderModel {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List? ?? [];
    List<OrderItemModel> parsedItems = rawItems
        .map((i) => OrderItemModel.fromJson(i))
        .toList();

    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 1,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Pending',
      items: parsedItems,
    );
  }
}
