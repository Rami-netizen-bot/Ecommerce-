import 'package:flutter/material.dart';

class OrderItemModel {
  final int id;
  final int productId;
  final int quantity;

  OrderItemModel({required this.id, required this.productId, required this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
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
    List<OrderItemModel> parsedItems = rawItems.map((i) => OrderItemModel.fromJson(i)).toList();

    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      items: parsedItems,
    );
  }
}