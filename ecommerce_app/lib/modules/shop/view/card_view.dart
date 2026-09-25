import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/modules/shop/controllers/card_controller.dart';
import 'package:ecommerce_app/modules/shop/view/payment_view.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Shopping Cart')),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_bag,
                        color: Colors.indigo,
                      ),
                      title: Text(cartItem.product.title, maxLines: 1),
                      subtitle: Text(
                        '\$${cartItem.product.price.toStringAsFixed(2)} x ${cartItem.quantity}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cartController.updateQuantity(
                              cartItem.product,
                              cartItem.quantity - 1,
                            ),
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cartController.updateQuantity(
                              cartItem.product,
                              cartItem.quantity + 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartController.removeFromCart(cartItem.product);
                              Get.snackbar(
                                "Removed",
                                "${cartItem.product.title} removed from cart",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.withOpacity(0.1),
                                colorText: Colors.red[800],
                                duration: Duration(seconds: 2),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${cartController.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: cartController.isLoading.value
                            ? null
                            : () {
                                final amount = cartController.totalPrice;

                                final dummyQr =
                                    "00020101021230580016a0000006770101110113000685500150303KHM5303840540${amount.toInt()}5802KH5909Merchant6007PhnomPenh6304";
                                Get.to(
                                  () => PaymentView(
                                    qrString: dummyQr,
                                    amount: amount,
                                  ),
                                );
                              },

                        child: cartController.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Checkout'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
