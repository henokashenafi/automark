import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient / Wave
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AskualaTheme.primaryColor.withOpacity(0.1),
              ),
            ),
          ).animate().scale(duration: 1200.ms, curve: Curves.easeOutBack),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo / Branding
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AskualaTheme.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AskualaTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.fact_check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ).animate().fade().slideY(begin: 0.2),
                          const SizedBox(height: 20),
                          Text(
                            'ASKUALA EXAM',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              letterSpacing: 2,
                              fontSize: 24,
                            ),
                          ).animate().fade(delay: 200.ms),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    Text(
                      'Exam Marker',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ).animate().fade(delay: 300.ms).slideX(begin: -0.1),
                    
                    const SizedBox(height: 8),
                    Text(
                      'Log in to start marking sheets',
                      style: TextStyle(color: AskualaTheme.mutedTextColor),
                    ).animate().fade(delay: 400.ms),
                    
                    const SizedBox(height: 40),
                    
                    // Login Form
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                      ),
                    ).animate().fade(delay: 500.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 20),
                    
                    TextField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ).animate().fade(delay: 600.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 32),
                    
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: const Text('Sign In'),
                    ).animate().fade(delay: 800.ms).scale(begin: const Offset(0.95, 0.95)),
                    
                    const SizedBox(height: 40),
                    
                    Center(
                      child: Text(
                        'Powered by Askuala Link',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AskualaTheme.mutedTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).animate().fade(delay: 1000.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
