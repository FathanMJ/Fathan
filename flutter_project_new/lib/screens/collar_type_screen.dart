import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';
import 'design_upload_screen.dart';
import '../services/master_data_service.dart';

class CollarTypeScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;
  final String selectedSizeType;
  final Map<String, dynamic> sizeTypeData;
  final Map<String, int> selectedSizes;
  final String selectedSleeveLength;
  final Map<String, dynamic> sleeveData;

  const CollarTypeScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
    required this.selectedSizeType,
    required this.sizeTypeData,
    required this.selectedSizes,
    required this.selectedSleeveLength,
    required this.sleeveData,
  });

  @override
  State<CollarTypeScreen> createState() => _CollarTypeScreenState();
}

class _CollarTypeScreenState extends State<CollarTypeScreen> {
  String? _selectedCollarType;
  List<Map<String, dynamic>> _collarOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollarTypes();
  }

  Future<void> _loadCollarTypes() async {
    try {
      final collarTypes = await MasterDataService.getCollarTypes();
      if (mounted) {
        setState(() {
          _collarOptions = collarTypes;
          _isLoading = false;
          
          // Auto-select first option if available
          if (_collarOptions.isNotEmpty) {
    final applicableOptions = _collarOptions
        .where((option) => option['applicable'].contains(widget.selectedProduct.name))
        .toList();
    
    if (applicableOptions.isNotEmpty) {
      _selectedCollarType = applicableOptions.first['type'];
            }
          }
        });
      }
    } catch (e) {
      print('Error loading collar types: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tipe Kerah',
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
          Expanded(child: _buildCollarOptions()),
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
                  Icons.sports,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Pilih Tipe Kerah',
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
          Text(
            'Pilih tipe kerah yang sesuai untuk ${widget.selectedProduct.name}',
            style: const TextStyle(
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
          _buildStepBox('3', 'Pilih\nUkuran', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('4', 'Detail\nUkuran', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('5', 'Pilih\nKerah', true),
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

  Widget _buildCollarOptions() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final applicableOptions = _collarOptions
        .where((option) => option['applicable'].contains(widget.selectedProduct.name))
        .toList();

    if (applicableOptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada tipe kerah tersedia',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applicableOptions.length,
      itemBuilder: (context, index) {
        final collarOption = applicableOptions[index];
        final isSelected = _selectedCollarType == collarOption['type'];

        return _buildCollarOptionCard(collarOption, isSelected);
      },
    );
  }

  Widget _buildCollarOptionCard(Map<String, dynamic> collarOption, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCollarType = collarOption['type'];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.borderColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  collarOption['iconData'] ?? Icons.circle_outlined,
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collarOption['type'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isSelected ? AppColors.primary : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      collarOption['description'],
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  collarOption['priceAdjustment'] == 0
                      ? 'Standard'
                      : '+ Rp ${collarOption['priceAdjustment'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : AppColors.text,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextStepButton() {
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
        onPressed: _selectedCollarType == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DesignUploadScreen(
                      selectedProduct: widget.selectedProduct,
                      selectedMaterial: widget.selectedMaterial,
                      selectedSizeType: widget.selectedSizeType,
                      sizeTypeData: widget.sizeTypeData,
                      selectedSizes: widget.selectedSizes,
                      selectedSleeveLength: widget.selectedSleeveLength,
                      sleeveData: widget.sleeveData,
                      selectedCollarType: _selectedCollarType!,
                      collarData: _collarOptions.firstWhere(
                        (option) => option['type'] == _selectedCollarType,
                      ),
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: _selectedCollarType == null
              ? AppColors.textLight
              : AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: _selectedCollarType == null ? 0 : 4,
        ),
        child: const Text(
          'Upload Desain',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
