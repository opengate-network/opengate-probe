import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [PasswordForm()],
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: loginController,
            decoration: const InputDecoration(
              labelText: 'Login',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
        ],
      ),
    );
  }
}
