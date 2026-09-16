import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './modules/shop/view/shop_view.dart';
import './modules/shop/controllers/shop_controllers.dart';
import './modules/shop/controllers/card_controller.dart';
import './modules/shop/view/login_view.dart';

void main() {
  Get.put(ShopController());
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home:  LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
