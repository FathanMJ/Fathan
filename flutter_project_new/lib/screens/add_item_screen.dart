import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';
import '../models/order_item.dart';
import 'cart_screen.dart';
import '../services/master_data_service.dart';

class AddItemScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;
  final Map<String, int> selectedSizes;
  final String selectedSleeveLength;
  final Map<String, dynamic> sleeveData;
  final String selectedCollarType;
  final Map<String, dynamic> collarData;
  final bool hasOwnDesign;
  final Map<String, dynamic> designData;

  const AddItemScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
    required this.selectedSizes,
    required this.selectedSleeveLength,
    required this.sleeveData,
    required this.selectedCollarType,
    required this.collarData,
    required this.hasOwnDesign,
    required this.designData,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool _isPlayer = true;
  String? _baseColor;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Map<String, dynamic>> _colorOptions = [];
  bool _isLoadingColors = true;

  @override
  void initState() {
    super.initState();
    _quantityController.text = _isPlayer ? '15' : '2';
    _loadWarna();
  }

  Future<void> _loadWarna() async {
    try {
      final warnas = await MasterDataService.getWarna();
      if (mounted) {
        setState(() {
          _colorOptions = warnas;
          _isLoadingColors = false;
          // Auto-select first color if available
          if (_colorOptions.isNotEmpty && _baseColor == null) {
            _baseColor = _colorOptions.first['nama'];
          }
        });
      }
    } catch (e) {
      print('Error loading warna: $e');
      if (mounted) {
        setState(() {
          _isLoadingColors = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tambah Item',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildItemTypeSelection(),
            const SizedBox(height: 16),
            _buildColorSelection(),
            const SizedBox(height: 16),
            _buildQuantityInput(),
            const SizedBox(height: 16),
            _buildNotesInput(),
            const SizedBox(height: 16),
            _buildOrderSummary(),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildHeader() {
    return Container(
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
                  Icons.add_shopping_cart,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tambah Item ke Pesanan',
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
            'Konfigurasi item terakhir sebelum menambahkan ke keranjang',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTypeSelection() {
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
            'Tipe Item',
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
                      _isPlayer = true;
                      _quantityController.text = '15';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isPlayer
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isPlayer
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          color: _isPlayer
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pemain',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isPlayer
                                ? AppColors.primary
                                : AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jersey untuk pemain',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isPlayer
                                ? AppColors.primary
                                : AppColors.textLight,
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
                      _isPlayer = false;
                      _quantityController.text = '2';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: !_isPlayer
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_isPlayer
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sports_handball,
                          color: !_isPlayer
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kiper',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !_isPlayer
                                ? AppColors.primary
                                : AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jersey untuk kiper',
                          style: TextStyle(
                            fontSize: 12,
                            color: !_isPlayer
                                ? AppColors.primary
                                : AppColors.textLight,
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

  Widget _buildColorSelection() {
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
            'Warna Dasar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoadingColors)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_colorOptions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tidak ada warna tersedia',
                  style: TextStyle(color: AppColors.textLight),
                ),
              ),
            )
          else
          Wrap(
            spacing: 12,
            runSpacing: 12,
              children: _colorOptions.map((colorData) {
                final colorName = colorData['nama'] ?? '';
                final kodeHex = colorData['kode_hex'] as String?;
                final isSelected = _baseColor == colorName;
                
              return InkWell(
                onTap: () {
                  setState(() {
                      _baseColor = colorName;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderColor,
                      width: 2,
                    ),
                  ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (kodeHex != null && kodeHex.isNotEmpty)
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: _parseHexColor(kodeHex),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                            ),
                          ),
                        Text(
                          colorName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.text,
                    ),
                        ),
                      ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _parseHexColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (e) {
      print('Error parsing hex color: $hex');
    }
    return AppColors.textLight;
  }

  Widget _buildQuantityInput() {
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
            'Jumlah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Masukkan jumlah',
              prefixIcon: const Icon(Icons.numbers),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesInput() {
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
            'Catatan (Opsional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tambahkan catatan khusus untuk item ini...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final totalQuantity = int.tryParse(_quantityController.text) ?? 0;
    final itemPrice = _calculateItemPrice();
    final totalPrice = itemPrice * totalQuantity;

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
            'Ringkasan Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Tipe', _isPlayer ? 'Pemain' : 'Kiper'),
          _buildSummaryRow('Warna', _baseColor ?? '-'),
          _buildSummaryRow('Jumlah', '$totalQuantity pcs'),
          _buildSummaryRow('Harga per item', 'Rp ${itemPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
          const Divider(),
          _buildSummaryRow(
            'Total Harga',
            'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppColors.text,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppColors.primary : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 56),
                side: const BorderSide(color: AppColors.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _addToCart();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 56),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Tambah ke Keranjang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateItemPrice() {
    // Get base price from selected product (if available) or use default
    double basePrice = double.tryParse(widget.selectedProduct.minPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 89000;
    double materialPrice = _getMaterialPrice();
    double sleevePrice = widget.sleeveData['priceAdjustment']?.toDouble() ?? 0;
    double collarPrice = widget.collarData['priceAdjustment']?.toDouble() ?? 0;
    double designPrice = widget.designData['price']?.toDouble() ?? 0;
    
    return basePrice + materialPrice + sleevePrice + collarPrice + designPrice;
  }

  double _getMaterialPrice() {
    // Use priceIncreaseValue from selectedMaterial instead of hardcoded values
    return widget.selectedMaterial.priceIncreaseValue.toDouble();
  }

  void _addToCart() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah harus lebih dari 0'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final orderItem = OrderItem(
      id: Random().nextInt(1000000).toString(),
      productName: widget.selectedProduct.name,
      materialName: widget.selectedMaterial.name,
      sizes: widget.selectedSizes,
      sleeveLength: widget.selectedSleeveLength,
      collarType: widget.selectedCollarType,
      baseColor: _baseColor ?? '',
      totalQuantity: quantity,
      isPlayer: _isPlayer,
      designFile: widget.hasOwnDesign ? widget.designData['file'] : null,
      templateName: widget.hasOwnDesign ? null : widget.designData['name'],
      basePrice: 89000,
      materialPrice: _getMaterialPrice(),
      sleevePrice: widget.sleeveData['priceAdjustment']?.toDouble() ?? 0,
      collarPrice: widget.collarData['priceAdjustment']?.toDouble() ?? 0,
      designPrice: widget.designData['price']?.toDouble() ?? 0,
      totalPrice: _calculateItemPrice() * quantity,
    );

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 8),
              const Text('Item Ditambahkan'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_isPlayer ? 'Jersey Pemain' : 'Jersey Kiper'} berhasil ditambahkan!'),
              const SizedBox(height: 8),
              Text('Warna: ${_baseColor ?? '-'}'),
              Text('Jumlah: $quantity pcs'),
              Text('Total: Rp ${orderItem.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Tambah Item Lain'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Lihat Keranjang'),
            ),
          ],
        );
      },
    );
  }
}
