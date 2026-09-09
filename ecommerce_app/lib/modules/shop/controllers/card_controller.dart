import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/models/card_item_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000'));
  void addToCart(Product product, {int quantity = 1}) {
    // Check if product already exists in cart
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
    Get.snackbar(
      'Cart Updated',
      '${product.title} added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: true,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  void updateQuantity(Product product, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity > 0) {
        cartItems[index].quantity = quantity;
        cartItems.refresh();
      } else {
        removeFromCart(product);
      }
    }
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalprice);
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
  Future<void> checkout() async {
    if (cartItems.isEmpty) return;

    try {
      isLoading.value = true;

      final orderPayload = {
        "user_id": 1, // Matches your default user setup
        "total_price": totalPrice,
        "items": cartItems.map((item) => {
          "product_id": item.product.id,
          "quantity": item.quantity,
        }).toList(),
      };

      final response = await _dio.post('/orders/', data: orderPayload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        cartItems.clear();
        Get.snackbar(
          'Checkout Successful',
          'Your order has been placed and saved to the database!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.deepPurple,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Checkout Failed',
        'Could not complete your order. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
