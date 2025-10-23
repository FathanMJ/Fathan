import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';

class PreviewOrderScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;
  final String selectedSizeType;
  final Map<String, dynamic> sizeTypeData;
  final Map<String, int> selectedSizes;
  final String selectedSleeveLength;
  final Map<String, dynamic> sleeveData;
  final bool hasOwnDesign;
  final Map<String, dynamic> designData;

  const PreviewOrderScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
    required this.selectedSizeType,
    required this.sizeTypeData,
    required this.selectedSizes,
    required this.selectedSleeveLength,
    required this.sleeveData,
    required this.hasOwnDesign,
    required this.designData,
  });

  @override
  State<PreviewOrderScreen> createState() => _PreviewOrderScreenState();
}

class _PreviewOrderScreenState extends State<PreviewOrderScreen> {
  int _totalQuantity = 0;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _calculateTotals() {
    // Calculate total quantity
    _totalQuantity = widget.selectedSizes.values.fold(0, (sum, qty) => sum + qty);
    
    // Calculate total price
    double basePrice = 89000; // Base price for the product
    double materialPrice = _getMaterialPrice();
    double sizeTypePrice = widget.sizeTypeData['priceAdjustment']?.toDouble() ?? 0;
    double sleevePrice = widget.sleeveData['priceAdjustment']?.toDouble() ?? 0;
    double designPrice = widget.designData['price']?.toDouble() ?? 0;
    
    double pricePerItem = basePrice + materialPrice + sizeTypePrice + sleevePrice + designPrice;
    _totalPrice = pricePerItem * _totalQuantity;
  }

  double _getMaterialPrice() {
    switch (widget.selectedMaterial.name) {
      case 'Cotton Combed 30s':
        return 0;
      case 'Cotton Combed 24s':
        return 10000;
      case 'Polyester':
        return 5000;
      case 'Fleece':
        return 25000;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Preview Pesanan',
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
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 16),
                  _buildProductDetails(),
                  const SizedBox(height: 16),
                  _buildPriceBreakdown(),
                  const SizedBox(height: 16),
                  _buildDeliveryInfo(),
                ],
              ),
            ),
          ),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
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
                  Icons.shopping_bag,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ringkasan Pesanan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Item:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$_totalQuantity pcs',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
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
            'Detail Produk',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Produk', widget.selectedProduct.name),
          _buildDetailRow('Bahan', widget.selectedMaterial.name),
          _buildDetailRow('Jenis Ukuran', widget.selectedSizeType),
          _buildDetailRow('Panjang Lengan', widget.selectedSleeveLength),
          _buildDetailRow(
            'Desain',
            widget.hasOwnDesign ? 'Upload Sendiri' : widget.designData['name'],
          ),
          const SizedBox(height: 16),
          _buildSizeBreakdown(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Ukuran:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...widget.selectedSizes.entries
            .where((entry) => entry.value > 0)
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ukuran ${entry.key}:'),
                      Text('${entry.value} pcs'),
                    ],
                  ),
                )),
      ],
    );
  }

  Widget _buildPriceBreakdown() {
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
            'Rincian Harga',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Harga Dasar', 89000),
          _buildPriceRow('Bahan (${widget.selectedMaterial.name})', _getMaterialPrice()),
          if (widget.sizeTypeData['priceAdjustment'] > 0)
            _buildPriceRow('Jenis Ukuran (${widget.selectedSizeType})', widget.sizeTypeData['priceAdjustment']),
          if (widget.sleeveData['priceAdjustment'] != 0)
            _buildPriceRow('Panjang Lengan', widget.sleeveData['priceAdjustment']),
          if (widget.designData['price'] > 0)
            _buildPriceRow('Desain', widget.designData['price']),
          _buildPriceRow('Subtotal (per item)', (_totalPrice / _totalQuantity).round()),
          const Divider(),
          _buildPriceRow('Jumlah Item', _totalQuantity, isQuantity: true),
          const Divider(thickness: 2),
          _buildPriceRow(
            'Total Harga',
            _totalPrice.round(),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, dynamic value, {bool isQuantity = false, bool isTotal = false}) {
    final price = isQuantity ? '$value pcs' : 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.text : AppColors.textLight,
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: isTotal ? AppColors.primary : AppColors.text,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
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
            'Informasi Pengiriman',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Estimasi Waktu Produksi: 5-7 hari kerja',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ongkir akan dihitung saat checkout',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp ${_totalPrice.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCheckoutDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
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

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              SizedBox(width: 8),
              Text('Pesanan Ditambahkan'),
            ],
          ),
          content: Text(
            'Pesanan custom order Anda telah ditambahkan ke keranjang dengan total $_totalQuantity pcs.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Lanjut Belanja'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Navigate to cart
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
