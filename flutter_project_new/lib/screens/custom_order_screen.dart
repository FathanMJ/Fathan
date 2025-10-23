import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../product_model.dart';
import '../utils/page_transitions.dart';
import 'material_selection_screen.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  final List<Product> _baseProducts = [
    const Product(
      name: 'Regular Fit Slagan',
      image: 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
      description: 'Kaos polos berkualitas tinggi',
      minPrice: 'Rp 89.000',
    ),
    const Product(
      name: 'Regular Fit Polo',
      image: 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
      description: 'Polo shirt elegan dan nyaman',
      minPrice: 'Rp 129.000',
    ),
    const Product(
      name: 'Regular Fit V-Neck',
      image: 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
      description: 'T-shirt V-neck stylish',
      minPrice: 'Rp 99.000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Custom Order',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            _buildProductGrid(),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
        children: const [
          Text(
            'Pilih Produk Dasar',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Langkah 1 dari 4: Pilih produk yang ingin kamu customisasi',
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          _buildStepBox('1', 'Pilih\nProduk', true),
          _buildStepConnector(true),
          _buildStepBox('2', 'Pilih\nBahan', false),
          _buildStepConnector(false),
          _buildStepBox('3', 'Upload\nDesain', false),
          _buildStepConnector(false),
          _buildStepBox('4', 'Preview &\nCheckout', false),
        ],
      ),
    );
  }

  Widget _buildStepBox(String number, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isActive
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    )
                  : null,
              color: isActive ? null : AppColors.cardBackground,
              border: Border.all(
                color: isActive ? Colors.transparent : AppColors.borderColor,
                width: 2,
              ),
              boxShadow: isActive
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
              child: Text(
                number,
                style: TextStyle(
                  color: isActive ? AppColors.white : AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? AppColors.text : AppColors.textLight,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 25,
      height: 3,
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

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _baseProducts.length,
        itemBuilder: (context, index) {
          final product = _baseProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CustomPageTransitions.slideFromRight(
                  MaterialSelectionScreen(selectedProduct: product),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppColors.borderColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.cardBackground,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.cardBackground,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.textLight,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: AppColors.textLight,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.text,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.description,
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mulai dari',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                product.minPrice,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}