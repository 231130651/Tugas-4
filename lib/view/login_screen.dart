import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/controller/auth_controller.dart';
import '../utils/colors_util.dart';
import 'home_weather.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool obscurePassword = true;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = await AuthController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted && user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeWeatherScreen()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = "Email/Password yang dimasukkan salah";
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
                    "Login",
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
                if (errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: firstColors,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Login',
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
                      "Belum punya akun? ",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        "Register",
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
