import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart'; // AppTheme import edildi
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

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _nameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  void _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('error_all_fields'.tr());
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (_isSignUp) {
      if (name.isEmpty) {
        _showError('error_name_empty'.tr());
        return;
      }
      
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setString('username', name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('signup_success'.tr()),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      setState(() {
        _isSignUp = false;
        _passwordController.clear();
      });
    } else {
      final savedEmail = prefs.getString('email');
      final savedPassword = prefs.getString('password');
      final savedUsername = prefs.getString('username') ?? 'Kullanıcı';

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
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
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
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    final gradientColors = isDark
        ? [const Color(0xFF1A237E), theme.scaffoldBackgroundColor]
        : [Colors.teal.shade100, theme.scaffoldBackgroundColor];

    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = textColor.withValues(alpha: 0.6);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // --- SAĞ ÜST KÖŞE BUTONLARI (Dil ve Tema Değiştirici Yan Yana) ---
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  // Tema Değiştirici Buton
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: textColor.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            color: textColor,
                          ),
                          tooltip: isDark ? 'Koyu Tema / Dark Theme' : 'Açık Tema / Light Theme',
                          onPressed: () {
                            setState(() {
                              AppTheme.toggleTheme();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // İki buton arası boşluk
                  // Dil Değiştirici Buton
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: textColor.withValues(alpha: 0.2)),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.language, color: textColor),
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
                ],
              ),
            ),

            // --- GİRİŞ / KAYIT KARTI ---
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
                        color: textColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: textColor.withValues(alpha: 0.15),
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
                            color: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSignUp ? 'signup_title'.tr() : 'login_title'.tr(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isSignUp ? 'signup_subtitle'.tr() : 'login_subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: subTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          if (_isSignUp) ...[
                            _buildTextField(
                              controller: _nameController,
                              label: 'label_name'.tr(),
                              icon: Icons.person_outline,
                              textColor: textColor,
                              primaryColor: primaryColor,
                            ),
                            const SizedBox(height: 18),
                          ],

                          _buildTextField(
                            controller: _emailController,
                            label: 'label_email'.tr(),
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 18),

                          _buildTextField(
                            controller: _passwordController,
                            label: 'label_password'.tr(),
                            icon: Icons.lock_outline,
                            obscureText: true,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 32),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: isDark ? Colors.blueGrey.shade900 : Colors.white,
                              elevation: 4,
                              shadowColor: primaryColor.withValues(alpha: 0.4),
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
                                color: primaryColor,
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
    required Color textColor,
    required Color primaryColor,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: primaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: textColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: textColor.withValues(alpha: 0.05),
      ),
    );
  }
}