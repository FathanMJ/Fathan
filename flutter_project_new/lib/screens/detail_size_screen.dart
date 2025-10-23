import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import 'material_model.dart';
import 'sleeve_length_screen.dart';

class DetailSizeScreen extends StatefulWidget {
  final Product selectedProduct;
  final MaterialModel selectedMaterial;
  final String selectedSizeType;
  final Map<String, dynamic> sizeTypeData;

  const DetailSizeScreen({
    super.key,
    required this.selectedProduct,
    required this.selectedMaterial,
    required this.selectedSizeType,
    required this.sizeTypeData,
  });

  @override
  State<DetailSizeScreen> createState() => _DetailSizeScreenState();
}

class _DetailSizeScreenState extends State<DetailSizeScreen> {
  final Map<String, int> _sizeQuantities = {};

  final List<Map<String, dynamic>> _sizeOptions = [
    {'size': 'S', 'description': 'Small'},
    {'size': 'M', 'description': 'Medium'},
    {'size': 'L', 'description': 'Large'},
    {'size': 'XL', 'description': 'Extra Large'},
    {'size': 'XXL', 'description': 'Extra Extra Large'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize quantities to 0
    for (final size in _sizeOptions) {
      _sizeQuantities[size['size']] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Ukuran',
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
          _buildSizeInfo(),
          Expanded(child: _buildSizeSelection()),
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
              Expanded(
                child: Text(
                  'Detail Ukuran - ${widget.selectedSizeType}',
                  style: const TextStyle(
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
            'Pilih ukuran dan jumlah untuk setiap ukuran yang dibutuhkan',
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
          _buildStepBox('3', 'Pilih\nUkuran', false, isDone: true),
          _buildStepConnector(true),
          _buildStepBox('4', 'Detail\nUkuran', true),
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

  Widget _buildSizeInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tip: Untuk pesanan massal, Anda bisa memilih ukuran yang sama untuk semua item',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sizeOptions.length,
      itemBuilder: (context, index) {
        final sizeOption = _sizeOptions[index];
        final size = sizeOption['size'];
        final quantity = _sizeQuantities[size] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: quantity > 0
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: quantity > 0
                          ? AppColors.primary
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: quantity > 0
                            ? AppColors.primary
                            : AppColors.textLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        size,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        sizeOption['description'],
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 0
                          ? () {
                              setState(() {
                                _sizeQuantities[size] = quantity - 1;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: quantity > 0 ? AppColors.primary : AppColors.textLight,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _sizeQuantities[size] = quantity + 1;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextStepButton() {
    final totalQuantity = _sizeQuantities.values.fold(0, (sum, qty) => sum + qty);
    final hasSelection = totalQuantity > 0;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSelection)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total: $totalQuantity pcs',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: !hasSelection
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleeveLengthScreen(
                          selectedProduct: widget.selectedProduct,
                          selectedMaterial: widget.selectedMaterial,
                          selectedSizeType: widget.selectedSizeType,
                          sizeTypeData: widget.sizeTypeData,
                          selectedSizes: _sizeQuantities,
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
              'Lanjut ke Panjang Lengan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
