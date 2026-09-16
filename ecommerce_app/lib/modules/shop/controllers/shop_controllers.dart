import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';

class ShopController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var productList = <Product>[].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

  int skip = 0;
  final int limit = 10;
  var hasMore = true.obs;

  // Dynamically extract unique categories from products, ensuring 'All' is always first
  List<String> get categories {
    final uniqueCategories = productList
        .map((product) => product.category)
        .where((category) => category != null && category.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    return ['All', ...uniqueCategories];
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts(isRefresh: true);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    skip = 0;
    hasMore.value = true;
    fetchProducts(category: category == 'All' ? null : category, isRefresh: true);
  }

  void fetchProducts({String? category, bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        skip = 0;
        hasMore.value = true;
        isLoading(true);
      }

      var products = await _provider.fetchProducts(
        skip: skip,
        limit: limit,
        category: category,
      );

      if (products.length < limit) {
        hasMore.value = false;
      }

      if (isRefresh) {
        productList.value = products;
      } else {
        productList.assignAll(products);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (isRefresh) {
        isLoading(false);
      }
    }
  }

  void loadMoreProducts() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;

    try {
      skip += limit;
      var moreProducts = await _provider.fetchProducts(
        skip: skip,
        limit: limit,
        category: selectedCategory.value == 'All' ? null : selectedCategory.value,
      );

      if (moreProducts.isEmpty || moreProducts.length < limit) {
        hasMore.value = false;
      }

      productList.addAll(moreProducts);
    } catch (e) {
      skip -= limit; // Revert skip count if request fails
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingMore.value = false;
    }
  }

  List<Product> get filteredProducts {
    return productList.where((product) {
      final matchesCategory = selectedCategory.value == 'All' || product.category == selectedCategory.value;
      final matchesSearch = (product.title?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase()) || 
                            (product.description?.toLowerCase() ?? '').contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      isLoading(true);
      await _provider.createProduct(productData);
      fetchProducts(category: selectedCategory.value == 'All' ? null : selectedCategory.value, isRefresh: true);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}
