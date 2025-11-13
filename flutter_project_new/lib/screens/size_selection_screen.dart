import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';
import 'detail_size_screen.dart';
import '../services/master_data_service.dart';

class SizeSelectionScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;

  const SizeSelectionScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
  });

  @override
  State<SizeSelectionScreen> createState() => _SizeSelectionScreenState();
}

class _SizeSelectionScreenState extends State<SizeSelectionScreen> {
  String? _selectedSizeType;
  List<Map<String, dynamic>> _sizeTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSizeTypes();
  }

  Future<void> _loadSizeTypes() async {
    try {
      final sizeTypes = await MasterDataService.getSizeTypes();
      if (mounted) {
        setState(() {
          _sizeTypes = sizeTypes.map((st) {
            return {
              'type': st['name'],
              'description': _getSizeTypeDescription(st['name']),
              'priceAdjustment': st['priceAdjustment'] ?? 0,
              'icon': _getSizeTypeIcon(st['name']),
            };
          }).toList();
          _isLoading = false;
          
          // Auto-select first option if available
          if (_sizeTypes.isNotEmpty) {
            _selectedSizeType = _sizeTypes.first['type'];
          }
        });
      }
    } catch (e) {
      print('Error loading size types: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getSizeTypeDescription(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('anak') || lower.contains('child')) {
      return 'Ukuran untuk anak-anak (usia 3-12 tahun)';
    } else if (lower.contains('dewasa') || lower.contains('adult')) {
      return 'Ukuran standar untuk dewasa';
    } else if (lower.contains('oversize') || lower.contains('besar')) {
      return 'Ukuran besar dengan tambahan biaya';
    }
    return 'Ukuran standar';
  }

  IconData _getSizeTypeIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('anak') || lower.contains('child')) {
      return Icons.child_care;
    } else if (lower.contains('dewasa') || lower.contains('adult')) {
      return Icons.person;
    } else if (lower.contains('oversize') || lower.contains('besar')) {
      return Icons.open_in_full;
    }
    return Icons.straighten;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pilih Jenis Ukuran',
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
          Expanded(child: _buildSizeTypeList()),
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
                  Icons.straighten,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Pilih Jenis Ukuran',
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
            'Langkah 3 dari 6: Pilih kategori ukuran yang sesuai',
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
          _buildStepBox('3', 'Pilih\nUkuran', true),
          _buildStepConnector(false),
          _buildStepBox('4', 'Upload\nDesain', false),
          _buildStepConnector(false),
          _buildStepBox('5', 'Preview &\nCheckout', false),
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

  Widget _buildSizeTypeList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_sizeTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.straighten_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jenis ukuran tersedia',
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
      itemCount: _sizeTypes.length,
      itemBuilder: (context, index) {
        final sizeType = _sizeTypes[index];
        final isSelected = _selectedSizeType == sizeType['type'];

        return _buildSizeTypeCard(sizeType, isSelected);
      },
    );
  }

  Widget _buildSizeTypeCard(Map<String, dynamic> sizeType, bool isSelected) {
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
            _selectedSizeType = sizeType['type'];
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
                  sizeType['icon'],
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
                      sizeType['type'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isSelected ? AppColors.primary : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sizeType['description'],
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (sizeType['priceAdjustment'] > 0)
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
                    '+ Rp ${sizeType['priceAdjustment'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.text,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Standard',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
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
        onPressed: _selectedSizeType == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSizeScreen(
                      selectedProduct: widget.selectedProduct,
                      selectedMaterial: widget.selectedMaterial,
                      selectedSizeType: _selectedSizeType!,
                      sizeTypeData: _sizeTypes.firstWhere(
                        (type) => type['type'] == _selectedSizeType,
                      ),
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: _selectedSizeType == null
              ? AppColors.textLight
              : AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: _selectedSizeType == null ? 0 : 4,
        ),
        child: const Text(
          'Lanjut ke Detail Ukuran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
