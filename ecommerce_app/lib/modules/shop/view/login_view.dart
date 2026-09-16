import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_view.dart';
import 'package:ecommerce_app/data/providers/auth_provider.dart';
import '../../shop/view/shop_view.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final AuthProvider _authProvider = AuthProvider();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Obx(() => isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    onPressed: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      try {
                        isLoading.value = true;
                        await _authProvider.login(emailController.text.trim(), passwordController.text.trim());
                        Get.offAll(() => const ShopView());
                      } catch (e) {
                        Get.snackbar('Error', 'Invalid credentials or network issue', snackPosition: SnackPosition.BOTTOM);
                      } finally {
                        isLoading.value = false;
                      }
                    },
                    child: const Text('Login'),
                  )),
            TextButton(
              onPressed: () => Get.to(() => RegisterView()),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}