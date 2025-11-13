import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'services/laravel_api_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 0.6, 1.0],
                colors: [
                  Colors.white,
                  Colors.white,
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),

          // Form content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Nama Lengkap
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        'Nama Lengkap',
                        Icons.person,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama lengkap wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email', Icons.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email wajib diisi';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration('Password', Icons.lock)
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nomor Telepon
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(
                        'Nomor Telepon',
                        Icons.phone,
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[0-9]{10,13}$').hasMatch(value)) {
                            return 'Nomor telepon tidak valid';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Alamat (opsional)
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: _inputDecoration(
                        'Alamat (opsional)',
                        Icons.home,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign Up dengan Email Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleRegister,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text;
        final name = _nameController.text.trim();
        final phone = _phoneController.text.trim();
        final address = _addressController.text.trim();

        // Step 1: Register dengan Firebase Auth
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Update display name di Firebase
        await userCredential.user?.updateDisplayName(name);
        await userCredential.user?.reload();
        final firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser == null) {
          throw Exception('Firebase user creation failed');
        }

        // Step 2: Get ID token dan sync ke Laravel/SQL
        final idToken = await firebaseUser.getIdToken();

        try {
          final response = await LaravelApiService.post(
            '/register/firebase',
            body: {'id_token': idToken, 'alamat': address, 'telepon': phone},
            requiresAuth: false,
          );

          if (response['success'] == true) {
            final data = response['data'] as Map<String, dynamic>?;
            final token = data != null ? data['token'] as String? : null;
            final emailVerified = data != null
                ? (data['email_verified'] as bool? ?? false)
                : false;

            if (token != null) {
              await LaravelApiService.saveToken(token);
            }

            if (mounted) {
              // Check if email is verified
              if (!emailVerified && !firebaseUser.emailVerified) {
                // Email belum verified, kirim ulang email verifikasi
                await firebaseUser.sendEmailVerification();

                _showEmailVerificationDialog();
              } else {
                // Email sudah verified atau langsung verified, arahkan ke home
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registrasi berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          } else {
            throw Exception(response['message'] ?? 'Gagal sync ke server');
          }
        } catch (e) {
          // Jika sync ke Laravel gagal, tetap biarkan user login dengan Firebase
          // User bisa login lagi nanti dan data akan sync
          if (mounted) {
            if (!firebaseUser.emailVerified) {
              await firebaseUser.sendEmailVerification();
              _showEmailVerificationDialog();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Registrasi berhasil, tetapi gagal sync ke server: $e',
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registrasi gagal';
        if (e.code == 'weak-password') {
          errorMessage = 'Password terlalu lemah';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Email sudah terdaftar';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Email tidak valid';
        } else {
          errorMessage = e.message ?? 'Registrasi gagal';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registrasi gagal: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verifikasi Email'),
        content: const Text(
          'Kami telah mengirim email verifikasi ke alamat email Anda. '
          'Silakan cek inbox Anda dan klik link verifikasi untuk mengaktifkan akun.\n\n'
          'Setelah email diverifikasi, Anda dapat login dengan akun yang baru dibuat.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to auth selection
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
