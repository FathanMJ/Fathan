import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/product_detail.dart';
import '../models/order_item.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetail? _product;
  bool _isLoading = true;
  String? _error;
  int _quantity = 1;
  int _currentImageIndex = 0;
  int? _selectedVariantId; // Selected variant ID for "biasa" products

  @override
  void initState() {
    super.initState();
    _loadProductDetail();
  }

  Future<void> _loadProductDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = await ProductService.getProductDetail(widget.productId);
      if (product == null) {
        setState(() {
          _error = 'Produk tidak ditemukan';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _product = product;
        _isLoading = false;
        // Auto-select first variant for "biasa" products
        if (product.isBiasa && product.varian.isNotEmpty) {
          _selectedVariantId = product.varian.first.idVarian;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat detail produk: $e';
        _isLoading = false;
      });
    }
  }

  void _incrementQuantity() {
    if (_product != null) {
      final maxQuantity = _product!.totalStok;
      if (_quantity < maxQuantity) {
        setState(() {
          _quantity++;
        });
      }
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  double _getTotalPrice() {
    if (_product == null) return 0;
    
    return _getUnitPrice() * _quantity;
  }
  
  double _getUnitPrice() {
    if (_product == null) return 0;
    
    double basePrice = _product!.hargaDasar ?? 0;
    
    // For biasa products, use selected variant price
    if (_product!.isBiasa && _selectedVariantId != null) {
      final selectedVariant = _product!.varian.firstWhere(
        (v) => v.idVarian == _selectedVariantId,
        orElse: () => _product!.varian.first,
      );
      basePrice = basePrice + selectedVariant.hargaTambahan;
    } else if (_product!.isBiasa && _product!.varian.isNotEmpty) {
      // Fallback to minimum price if no variant selected
      final minVariantPrice = _product!.varian
          .map((v) => v.hargaTambahan)
          .reduce((a, b) => a < b ? a : b);
      basePrice = basePrice + minVariantPrice;
    }
    
    return basePrice;
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _addToCart() {
    if (_product == null) return;

    // For "biasa" products, validate variant selection
    if (_product!.isBiasa) {
      if (_selectedVariantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih ukuran terlebih dahulu'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Validate variant stock
      final selectedVariant = _product!.varian.firstWhere(
        (v) => v.idVarian == _selectedVariantId,
      );
      
      if (selectedVariant.stok <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stok varian ini habis'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (selectedVariant.stok < _quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok tidak mencukupi. Stok tersedia: ${selectedVariant.stok}'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else {
      // For custom products, validate total stock
      final totalStok = _product!.totalStok;
      if (totalStok <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stok produk habis'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (totalStok < _quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok tidak mencukupi. Stok tersedia: $totalStok'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    // Create order item with varianId for "biasa" products
    final unitPrice = _getUnitPrice();
    final orderItem = OrderItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      productName: _product!.nama,
      materialName: '', // Not applicable for "biasa" products
      sizes: {}, // Not applicable for "biasa" products
      sleeveLength: '', // Not applicable for "biasa" products
      collarType: '', // Not applicable for "biasa" products
      baseColor: '', // Not applicable for "biasa" products
      totalQuantity: _quantity,
      isPlayer: false, // Not applicable for "biasa" products
      designFile: null,
      templateName: null,
      basePrice: _product!.hargaDasar ?? 0,
      materialPrice: 0,
      sleevePrice: 0,
      collarPrice: 0,
      designPrice: 0,
      totalPrice: unitPrice * _quantity,
      varianId: _selectedVariantId, // This is required for checkout
    );

    // Add to cart and navigate to cart screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produk ditambahkan ke keranjang'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to cart screen with the new item
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(initialItem: orderItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProductDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(child: Text('Produk tidak ditemukan'))
                  : _buildProductDetail(),
    );
  }

  Widget _buildProductDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Carousel
          _buildImageCarousel(),
          
          // Product Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  _product!.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Category
                if (_product!.kategoriNama != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _product!.kategoriNama!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Price
                _buildPriceSection(),
                const SizedBox(height: 16),
                
                // Description
                if (_product!.deskripsi.isNotEmpty) ...[
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product!.deskripsi,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Variant Selection (for "biasa" products)
                if (_product!.isBiasa && _product!.varian.isNotEmpty) ...[
                  _buildVariantSelector(),
                  const SizedBox(height: 16),
                ],
                
                // Stock Info
                _buildStockInfo(),
                const SizedBox(height: 16),
                
                // Quantity Selector
                _buildQuantitySelector(),
                const SizedBox(height: 24),
                
                // Add to Cart Button
                _buildAddToCartButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (_product!.imageUrls.isEmpty) {
      return Container(
        height: 300,
        color: AppColors.cardBackground,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64, color: AppColors.textLight),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: _product!.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = _product!.imageUrls[index];
              if (imageUrl.isEmpty) {
                return Container(
                  color: AppColors.cardBackground,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: AppColors.textLight,
                  ),
                );
              }
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.cardBackground,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.cardBackground,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                  );
                },
              );
            },
          ),
          if (_product!.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _product!.imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? AppColors.primary
                          : AppColors.textLight.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final unitPrice = _getUnitPrice();
    return Text(
      'Rp ${_formatPrice(unitPrice)}',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }


  Widget _buildStockInfo() {
    final totalStok = _product!.totalStok;
    final isOutOfStock = totalStok <= 0;
    final isLowStock = totalStok <= 5 && totalStok > 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOutOfStock
            ? AppColors.error.withOpacity(0.1)
            : (isLowStock ? Colors.orange.withOpacity(0.1) : AppColors.success.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOutOfStock
              ? AppColors.error
              : (isLowStock ? Colors.orange : AppColors.success),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOutOfStock
                ? Icons.cancel_outlined
                : (isLowStock ? Icons.warning_amber_rounded : Icons.check_circle_outline),
            color: isOutOfStock
                ? AppColors.error
                : (isLowStock ? Colors.orange : AppColors.success),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isOutOfStock
                ? 'Stok Habis'
                : (isLowStock ? 'Stok Terbatas: $totalStok tersedia' : 'Stok: $totalStok tersedia'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isOutOfStock
                  ? AppColors.error
                  : (isLowStock ? Colors.orange : AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelector() {
    if (_product == null || !_product!.isBiasa || _product!.varian.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Ukuran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _product!.varian.map((variant) {
            final isSelected = _selectedVariantId == variant.idVarian;
            final isOutOfStock = variant.stok <= 0;
            
            return InkWell(
              onTap: isOutOfStock ? null : () {
                setState(() {
                  _selectedVariantId = variant.idVarian;
                  // Reset quantity if it exceeds variant stock
                  if (_quantity > variant.stok) {
                    _quantity = variant.stok;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isOutOfStock ? AppColors.cardBackground : AppColors.white),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isOutOfStock ? AppColors.borderColor.withOpacity(0.3) : AppColors.borderColor),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.ukuranDetailNama ?? 'Ukuran ${variant.idVarian}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : (isOutOfStock ? AppColors.textLight : AppColors.text),
                      ),
                    ),
                    if (variant.hargaTambahan > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '+ Rp ${_formatPrice(variant.hargaTambahan)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.white.withOpacity(0.9)
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      isOutOfStock ? 'Habis' : 'Stok: ${variant.stok}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? AppColors.white.withOpacity(0.8)
                            : (isOutOfStock ? AppColors.error : AppColors.textLight),
                        fontWeight: isOutOfStock ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    // For "biasa" products, use selected variant stock
    // For custom products, use total stock
    final maxQuantity = _product!.isBiasa && _selectedVariantId != null
        ? _product!.varian.firstWhere((v) => v.idVarian == _selectedVariantId).stok
        : _product!.totalStok;

    return Column(
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
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? _decrementQuantity : null,
                    icon: const Icon(Icons.remove, size: 20),
                    color: _quantity > 1 ? AppColors.text : AppColors.textLight,
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _quantity < maxQuantity ? _incrementQuantity : null,
                    icon: const Icon(Icons.add, size: 20),
                    color: _quantity < maxQuantity ? AppColors.text : AppColors.textLight,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Total: Rp ${_formatPrice(_getTotalPrice())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    final totalStok = _product!.totalStok;
    final canAddToCart = totalStok > 0 && _quantity <= totalStok;
    final errorMessage = totalStok <= 0 
        ? 'Stok habis' 
        : (_quantity > totalStok ? 'Stok tidak mencukupi' : null);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: canAddToCart ? _addToCart : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 20),
            const SizedBox(width: 8),
            Text(
              canAddToCart ? 'Tambah ke Keranjang' : (errorMessage ?? 'Tidak dapat ditambahkan'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

