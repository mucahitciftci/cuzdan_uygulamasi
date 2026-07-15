import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'wallet_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false;
  final _authBox = Hive.box('auth_box');

  void _handleAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('error_all_fields'.tr());
      return;
    }

    if (_isSignUp) {
      if (name.isEmpty) {
        _showError('error_name_empty'.tr());
        return;
      }
      
      _authBox.put('email', email);
      _authBox.put('password', password);
      _authBox.put('username', name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('signup_success'.tr()),
          backgroundColor: Colors.teal,
        ),
      );

      setState(() {
        _isSignUp = false;
        _passwordController.clear();
      });
    } else {
      final savedEmail = _authBox.get('email');
      final savedPassword = _authBox.get('password');
      final savedUsername = _authBox.get('username') ?? 'Kullanıcı';

      if (email == savedEmail && password == savedPassword) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WalletListScreen(username: savedUsername),
          ),
        );
      } else {
        _showError('error_auth_failed'.tr());
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text('error_title'.tr()),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('btn_ok'.tr()),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade900,
              Colors.blueGrey.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: Stack(
          children: [
            // --- DİL SEÇİM BUTONU (Sağ Üst Köşe - withValues Güncellemesiyle) ---
            Positioned(
              top: 40,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.language, color: Colors.white),
                      tooltip: 'Dil Değiştir / Change Language',
                      onPressed: () {
                        setState(() {
                          if (context.locale == const Locale('tr')) {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('tr'));
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            // --- GİRİŞ / KAYIT KARTI (withValues Güncellemesiyle) ---
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64,
                            color: Colors.tealAccent.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSignUp ? 'signup_title'.tr() : 'login_title'.tr(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isSignUp ? 'signup_subtitle'.tr() : 'login_subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          if (_isSignUp) ...[
                            _buildTextField(
                              controller: _nameController,
                              label: 'label_name'.tr(),
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 18),
                          ],

                          _buildTextField(
                            controller: _emailController,
                            label: 'label_email'.tr(),
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _passwordController,
                            label: 'label_password'.tr(),
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          const SizedBox(height: 32),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.tealAccent.shade400,
                              foregroundColor: Colors.blueGrey.shade900,
                              elevation: 4,
                              shadowColor: Colors.tealAccent.withValues(alpha: 0.4),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _handleAuth,
                            child: Text(
                              _isSignUp ? 'btn_signup'.tr() : 'btn_login'.tr(),
                              style: const TextStyle(
                                fontSize: 15, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignUp = !_isSignUp;
                              });
                            },
                            child: Text(
                              _isSignUp 
                                  ? 'switch_to_login'.tr() 
                                  : 'switch_to_signup'.tr(),
                              style: TextStyle(
                                color: Colors.tealAccent.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: Colors.tealAccent.shade400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.tealAccent.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}