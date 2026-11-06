import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }

  Future<void> register() async {
    if (passwordController.text != confirmController.text) {
      showAlert('Senhas não conferem!');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.pop(context); // fecha o loading
      Navigator.pop(context); // fecha a RegisterPage
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(switch (e.code) {
        'email-already-in-use' => 'Já existe um usuário com esse email!',
        'weak-password' => 'Escolha uma senha mais forte.',
        _ => 'Não foi possível cadastrar. Tente novamente.',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Crie sua conta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: passwordController,
                hintText: 'Senha',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: confirmController,
                hintText: 'Confirmar senha',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: register,
                text: 'Registrar',
                icon: Icons.person_add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
