import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/login_screen.dart';

class AuthController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Validasi format email
  static String? validateEmail(String email) {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) return 'Email tidak boleh kosong';
    if (!regex.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  /// Validasi password match (untuk register)
  static String? validatePasswordMatch(String password, String confirm) {
    if (password != confirm) return 'Password dan konfirmasi tidak sama';
    return null;
  }

  /// Validasi panjang password minimum
  static String? validatePasswordStrength(String password) {
    if (password.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  /// Proses Login
  static Future<User?> login(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return userCred.user;
  }

  /// Proses Register
  static Future<User?> register(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return userCred.user;
  }

  /// Proses Logout dan arahkan kembali ke LoginScreen
  static Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
