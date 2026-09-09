import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';

class ShopController extends GetxController {
  final ProductProvider _provider = ProductProvider();

  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

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
    fetchProducts();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchProducts(category: category == 'All' ? null : category);
  }

  void fetchProducts({String? category}) async {
    try {
      isLoading(true);
      var products = await _provider.fetchProducts(category: category == 'All' ? null : category);
      productList.value = products;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
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
      fetchProducts(category: selectedCategory.value == 'All' ? null : selectedCategory.value);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}

