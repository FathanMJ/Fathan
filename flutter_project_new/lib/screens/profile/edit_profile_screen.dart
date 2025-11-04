import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.initialData});

  final Map<String, dynamic>? initialData;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _authService = AuthService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = (widget.initialData?['nama'] ?? '').toString();
    _emailController.text = (widget.initialData?['email'] ?? '').toString();
    _phoneController.text = (widget.initialData?['pelanggan']?['telepon'] ?? '').toString();
    _addressController.text = (widget.initialData?['pelanggan']?['alamat'] ?? '').toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Nama Lengkap', _nameController, Icons.person, validator: (v) => (v==null||v.isEmpty)?'Nama wajib diisi':null),
              const SizedBox(height: 12),
              _buildField('Email', _emailController, Icons.email, keyboard: TextInputType.emailAddress,
                  validator: (v){
                    if(v==null||v.isEmpty) return 'Email wajib diisi';
                    final re = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                    if(!re.hasMatch(v)) return 'Email tidak valid';
                    return null;
                  }),
              const SizedBox(height: 12),
              _buildField('Nomor Telepon', _phoneController, Icons.phone, keyboard: TextInputType.phone),
              const SizedBox(height: 12),
              _buildField('Alamat', _addressController, Icons.home, maxLines: 2),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {String? Function(String?)? validator, TextInputType keyboard = TextInputType.text, int maxLines = 1}){
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    if(!_formKey.currentState!.validate()) return;
    setState(()=> _isSubmitting = true);
    try{
      await _authService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty? null : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty? null : _addressController.text.trim(),
      );
      if(!mounted) return;
      Navigator.of(context).pop(true);
    }catch(e){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }finally{
      if(mounted) setState(()=> _isSubmitting = false);
    }
  }
}


