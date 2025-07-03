import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors_util.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  void register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    final matchError = AuthController.validatePasswordMatch(password, confirm);
    final lengthError = AuthController.validatePasswordStrength(password);
    final emailError = AuthController.validateEmail(email);

    if (emailError != null || matchError != null || lengthError != null) {
      setState(() {
        errorMessage = emailError ?? matchError ?? lengthError;
        isLoading = false;
      });
      return;
    }

    try {
      await AuthController.register(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registrasi berhasil'),
            backgroundColor: firstColors,
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Image.asset('assets/logo.png', height: 140),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: firstColors,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: firstColors),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: firstColors),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: firstColors,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    labelStyle: TextStyle(color: firstColors),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        color: firstColors,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: firstColors, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: firstColors,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Register',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Punya akun? ",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(color: firstColors),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
