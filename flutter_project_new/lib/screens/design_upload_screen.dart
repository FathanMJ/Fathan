import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';
import 'add_item_screen.dart';

class DesignUploadScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;
  final Map<String, int> selectedSizes;
  final String selectedSleeveLength;
  final Map<String, dynamic> sleeveData;
  final String selectedCollarType;
  final Map<String, dynamic> collarData;

  const DesignUploadScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
    required this.selectedSizes,
    required this.selectedSleeveLength,
    required this.sleeveData,
    required this.selectedCollarType,
    required this.collarData,
  });

  @override
  State<DesignUploadScreen> createState() => _DesignUploadScreenState();
}

class _DesignUploadScreenState extends State<DesignUploadScreen> {
  bool _hasOwnDesign = false;
  String? _selectedTemplate;
  String? _uploadedFile;

  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Template Polos',
      'description': 'Produk tanpa desain tambahan',
      'image': 'https://placehold.co/300x200/F5F5F5/999999?text=Template+Polos',
      'price': 0,
    },
    {
      'name': 'Template Logo Sederhana',
      'description': 'Template dengan logo sederhana',
      'image': 'https://placehold.co/300x200/E3F2FD/1976D2?text=Logo+Template',
      'price': 25000,
    },
    {
      'name': 'Template Text',
      'description': 'Template dengan teks kustom',
      'image': 'https://placehold.co/300x200/F3E5F5/7B1FA2?text=Text+Template',
      'price': 15000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Upload Desain',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.borderColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildStepIndicator(),
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: _buildNextStepButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload_file,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Upload Desain',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload desain sendiri atau pilih template yang tersedia',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepBox('1', 'Pilih\nProduk', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('2', 'Pilih\nBahan', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('3', 'Detail\nUkuran', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('4', 'Upload\nDesain', true),
        ],
      ),
    );
  }

  Widget _buildStepBox(
    String number,
    String label,
    bool isActive, {
    bool isDone = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isActive || isDone
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    )
                  : null,
              color: (isActive || isDone) ? null : AppColors.cardBackground,
              border: Border.all(
                color: (isActive || isDone)
                    ? Colors.transparent
                    : AppColors.borderColor,
                width: 2,
              ),
              boxShadow: (isActive || isDone)
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isDone && !isActive
                  ? const Icon(Icons.check, color: AppColors.white, size: 18)
                  : Text(
                      number,
                      style: TextStyle(
                        color: (isActive || isDone)
                            ? AppColors.white
                            : AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: (isActive || isDone) ? AppColors.text : AppColors.textLight,
              fontWeight: (isActive || isDone) ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 20,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: isActive
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              )
            : null,
        color: isActive ? null : AppColors.borderColor,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDesignOption(),
          const SizedBox(height: 24),
          if (_hasOwnDesign) _buildUploadSection() else _buildTemplateSection(),
        ],
      ),
    );
  }

  Widget _buildDesignOption() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Jenis Desain',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasOwnDesign = false;
                      _uploadedFile = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !_hasOwnDesign
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_hasOwnDesign
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.design_services,
                          color: !_hasOwnDesign
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih Template',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !_hasOwnDesign
                                ? AppColors.primary
                                : AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _hasOwnDesign = true;
                      _selectedTemplate = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _hasOwnDesign
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _hasOwnDesign
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: _hasOwnDesign
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload Sendiri',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _hasOwnDesign
                                ? AppColors.primary
                                : AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload File Desain',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Format yang didukung: JPG, PNG, PDF, AI (Max 10MB)',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              // TODO: Implement file picker
              setState(() {
                _uploadedFile = 'design_file.pdf';
              });
            },
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: _uploadedFile != null
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _uploadedFile != null
                      ? AppColors.success
                      : AppColors.borderColor,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: _uploadedFile != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _uploadedFile!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _uploadedFile = null;
                            });
                          },
                          child: const Text('Ganti File'),
                        ),
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: AppColors.textLight,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap untuk upload file',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Template',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _templates.length,
          itemBuilder: (context, index) {
            final template = _templates[index];
            final isSelected = _selectedTemplate == template['name'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderColor.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.shadowColor,
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTemplate = template['name'];
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          template['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSelected ? AppColors.primary : AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template['description'],
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        template['price'] == 0
                            ? 'Gratis'
                            : '+ Rp ${template['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: template['price'] == 0
                              ? AppColors.success
                              : AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNextStepButton() {
    final hasSelection = _hasOwnDesign ? _uploadedFile != null : _selectedTemplate != null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: !hasSelection
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(
                      selectedProduct: widget.selectedProduct,
                      selectedMaterial: widget.selectedMaterial,
                      selectedSizes: widget.selectedSizes,
                      selectedSleeveLength: widget.selectedSleeveLength,
                      sleeveData: widget.sleeveData,
                      selectedCollarType: widget.selectedCollarType,
                      collarData: widget.collarData,
                      hasOwnDesign: _hasOwnDesign,
                      designData: _hasOwnDesign
                          ? {'file': _uploadedFile}
                          : _templates.firstWhere(
                              (template) => template['name'] == _selectedTemplate,
                            ),
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: !hasSelection
              ? AppColors.textLight
              : AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: !hasSelection ? 0 : 4,
        ),
        child: const Text(
          'Tambah Item',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
