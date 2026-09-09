import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/data/models/order_model.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000')); // Update based on your device platform

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _dio.get('/orders/1'); // Fetching for user_id = 1
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not load order history');
    } finally {
      isLoading.value = false;
    }
  }
}