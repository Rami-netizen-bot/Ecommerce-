import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/data/providers/auth_provider.dart';

class RegisterView extends StatelessWidget {
  RegisterView({Key? key}) : super(key: key);

  final AuthProvider _authProvider = AuthProvider();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
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
                      if (usernameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
                        Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.BOTTOM);
                        return;
                      }
                      try {
                        isLoading.value = true;
                        await _authProvider.register(
                          usernameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        Get.snackbar('Success', 'Account created successfully! Please login.', snackPosition: SnackPosition.BOTTOM);
                        Get.back();
                      } catch (e) {
                        Get.snackbar('Error', 'Registration failed', snackPosition: SnackPosition.BOTTOM);
                      } finally {
                        isLoading.value = false;
                      }
                    },
                    child: const Text('Register'),
                  )),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}