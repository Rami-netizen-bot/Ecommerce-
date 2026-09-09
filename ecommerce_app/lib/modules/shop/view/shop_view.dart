import 'package:ecommerce_app/modules/shop/controllers/card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/modules/shop/controllers/shop_controllers.dart';
import 'package:ecommerce_app/modules/shop/view/product_detail_view.dart';
import 'package:ecommerce_app/modules/shop/view/card_view.dart';
import 'package:ecommerce_app/modules/Widget/promo_banner.dart';
import 'package:ecommerce_app/data/models/promoe_banner_model.dart';
import 'package:ecommerce_app/modules/shop/view/order_history_view.dart';
import 'package:ecommerce_app/modules/shop/view/add_product_view.dart';

class ShopView extends StatelessWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShopController controller = Get.find<ShopController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart E-Commerce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchProducts(
              category: controller.selectedCategory.value,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.to(() => const OrderHistoryView()),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Get.to(() => const CartView()),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Obx(() {
                  final cartController = Get.find<CartController>();
                  if (cartController.totalItems == 0)
                    return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartController.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => controller.updateSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          PromoBannerCarousel(
            banners: [
              BannerModel(
                title: 'Big sale\nwow!',
                buttonText: 'Explore',
                backgroundColor: const Color(0xFFD1FAE5),
                imageUrl:
                    'https://img.buzzfeed.com/buzzfeed-static/static/2026-07/17/16/subbuzz/NDq5aTzjR.png?crop=2054%3A1278%3B204%2C58&downsize=700%3A%2A&output-quality=auto&output-format=auto',
              ),
              BannerModel(
                title: 'Special Promo\nUp to 50% Off',
                buttonText: 'Shop Now',
                backgroundColor: const Color(0xFFE8F1FC),
              ),
              BannerModel(
                title: 'Save money!\nGet rewards',
                buttonText: 'Learn more',
                backgroundColor: const Color(0xFFEDE9FE),
                imageUrl:
                    'https://img.buzzfeed.com/buzzfeed-static/static/2026-07/17/16/subbuzz/NDq5aTzjR.png?crop=2054%3A1278%3B204%2C58&downsize=700%3A%2A&output-quality=auto&output-format=auto',
              ),
            ],
            onBannerTap: (index) {},
          ),
          
          // Dynamic Category Selector Chips with Smooth Selection Animation
          Obx(
            () => SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  final isSelected = controller.selectedCategory.value == cat;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: ChoiceChip(
                        key: ValueKey('${cat}_$isSelected'),
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => controller.changeCategory(cat),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Product Grid View with Animated Transitions
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: GridView.builder(
                  key: ValueKey(controller.selectedCategory.value),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailView(), arguments: product);
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: product.imageUrl != null &&
                                          product.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          product.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Center(
                                            child: Icon(
                                              Icons.shopping_bag,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.shopping_bag,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => Get.to(() => AddProductView()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}