import 'laravel_api_service.dart';
import '../config/api_config.dart';
import '../product_model.dart';
import '../models/product_detail.dart';

class ProductService {
  // Get all products
  static Future<List<Product>> getProducts({
    String? search,
    int? kategoriId,
    String? tipeProduk, // 'biasa' or 'custom'
  }) async {
    try {
      String endpoint = ApiConfig.produk;
      List<String> queryParams = [];
      
      if (search != null && search.isNotEmpty) {
        queryParams.add('search=$search');
      }
      if (kategoriId != null) {
        queryParams.add('kategori_id=$kategoriId');
      }
      if (tipeProduk != null) {
        queryParams.add('tipe_produk=$tipeProduk');
      }
      
      if (queryParams.isNotEmpty) {
        endpoint += '?${queryParams.join('&')}';
      }
      
      print('🔍 Fetching products from: $endpoint');
      final response = await LaravelApiService.get(endpoint, requiresAuth: false);
      print('✅ Response received: ${response.keys}');
      
      // Handle pagination response structure
      // Laravel paginate returns: { success: true, data: { data: [...], current_page: 1, ... } }
      dynamic productsData;
      if (response['data'] != null) {
        if (response['data'] is Map && response['data']['data'] != null) {
          // Pagination response
          productsData = response['data']['data'];
          print('📦 Found ${productsData.length} products (paginated)');
        } else if (response['data'] is List) {
          // Direct list response
          productsData = response['data'];
          print('📦 Found ${productsData.length} products (direct list)');
        } else {
          productsData = [];
          print('⚠️ Unexpected data structure: ${response['data'].runtimeType}');
        }
      } else {
        productsData = [];
        print('⚠️ No data field in response');
      }
      
      if (productsData == null || productsData.isEmpty) {
        print('⚠️ No products found in response');
        return [];
      }
      
      return productsData.map<Product>((item) {
        String imageUrl = '';
        if (item['image_main'] != null && (item['image_main'] as String).isNotEmpty) {
          imageUrl = item['image_main'];
        } else if (item['fotos'] != null && item['fotos'].isNotEmpty) {
          final firstFoto = item['fotos'][0];
          if (firstFoto is Map && firstFoto['url'] != null && (firstFoto['url'] as String).isNotEmpty) {
            imageUrl = firstFoto['url'];
          } else if (firstFoto['nama_file'] != null) {
            String fotoPath = firstFoto['nama_file'];
            if (fotoPath.startsWith('public/')) {
              fotoPath = fotoPath.replaceFirst('public/', '');
            }
            String baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
            imageUrl = '$baseUrl/storage/$fotoPath';
          }
        }
        
        // If no photo, use placeholder
        if (imageUrl.isEmpty) {
          imageUrl = 'https://placehold.co/600x400/CCCCCC/666666?text=${Uri.encodeComponent(item['nama'] ?? 'Product')}';
          print('🖼️ Using placeholder for: ${item['nama']}');
        }
        
        // Parse harga_dasar - bisa string atau num
        double hargaDasar = 0;
        if (item['harga_dasar'] != null) {
          if (item['harga_dasar'] is String) {
            hargaDasar = double.tryParse(item['harga_dasar']) ?? 0;
          } else if (item['harga_dasar'] is num) {
            hargaDasar = (item['harga_dasar'] as num).toDouble();
          }
        }
        
        // Untuk produk biasa, hitung harga minimum (harga_dasar + harga_tambahan minimum dari varian)
        double minPrice = hargaDasar;
        final tipeProduk = item['tipe_produk'] ?? 'biasa';
        
        if (tipeProduk == 'biasa' && item['varian'] != null && (item['varian'] as List).isNotEmpty) {
          // Cari harga_tambahan minimum dari varian
          double minHargaTambahan = double.infinity;
          for (var varian in item['varian']) {
            double hargaTambahan = 0;
            if (varian['harga_tambahan'] != null) {
              if (varian['harga_tambahan'] is String) {
                hargaTambahan = double.tryParse(varian['harga_tambahan']) ?? 0;
              } else if (varian['harga_tambahan'] is num) {
                hargaTambahan = (varian['harga_tambahan'] as num).toDouble();
              }
            }
            if (hargaTambahan < minHargaTambahan) {
              minHargaTambahan = hargaTambahan;
            }
          }
          if (minHargaTambahan != double.infinity) {
            minPrice = hargaDasar + minHargaTambahan;
          }
        }
        
        // Format harga dengan titik sebagai pemisah ribuan
        String formattedPrice = minPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
        
        return Product(
          id: item['id_produk'] ?? item['id'],
          name: item['nama'] ?? '',
          image: imageUrl,
          description: item['deskripsi'] ?? '',
          minPrice: 'Rp $formattedPrice',
        );
      }).toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching products: $e');
      print('📍 Stack trace: $stackTrace');
      return [];
    }
  }

  // Get product by ID (simple version)
  static Future<Product?> getProductById(int id) async {
    try {
      final response = await LaravelApiService.get(
        '${ApiConfig.produk}/$id',
        requiresAuth: false,
      );
      
      final item = response['data'];
      if (item == null) return null;
      
      String imageUrl = '';
      if (item['image_main'] != null && (item['image_main'] as String).isNotEmpty) {
        imageUrl = item['image_main'];
      } else if (item['fotos'] != null && item['fotos'].isNotEmpty) {
        final firstFoto = item['fotos'][0];
        if (firstFoto is Map && firstFoto['url'] != null && (firstFoto['url'] as String).isNotEmpty) {
          imageUrl = firstFoto['url'];
        } else if (firstFoto['nama_file'] != null) {
          String fotoPath = firstFoto['nama_file'];
          if (fotoPath.startsWith('public/')) {
            fotoPath = fotoPath.replaceFirst('public/', '');
          }
          imageUrl = '${ApiConfig.baseUrl.replaceAll('/api', '')}/storage/$fotoPath';
        }
      }
      
      if (imageUrl.isEmpty) {
        imageUrl = 'https://placehold.co/600x400/CCCCCC/666666?text=${item['nama'] ?? 'Product'}';
  }

      // Parse harga_dasar - bisa string atau num
      double hargaDasar = 0;
      if (item['harga_dasar'] != null) {
        if (item['harga_dasar'] is String) {
          hargaDasar = double.tryParse(item['harga_dasar']) ?? 0;
        } else if (item['harga_dasar'] is num) {
          hargaDasar = (item['harga_dasar'] as num).toDouble();
        }
      }
      
      // Format harga dengan titik sebagai pemisah ribuan
      String formattedPrice = hargaDasar.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
      
      return Product(
        id: item['id_produk'] ?? item['id'],
        name: item['nama'] ?? '',
        image: imageUrl,
        description: item['deskripsi'] ?? '',
        minPrice: 'Rp $formattedPrice',
      );
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Get product detail with variants
  static Future<ProductDetail?> getProductDetail(int id) async {
    try {
      print('🔍 Fetching product detail for ID: $id');
      final response = await LaravelApiService.get(
        '${ApiConfig.produk}/$id',
        requiresAuth: false,
      );
      
      print('✅ Product detail response received');
      final item = response['data'];
      if (item == null) {
        print('⚠️ No product data found');
        return null;
      }
      
      print('📦 Parsing product detail...');
      final productDetail = ProductDetail.fromJson(item);
      print('✅ Product detail parsed: ${productDetail.nama}, ${productDetail.varian.length} variants');
      
      return productDetail;
    } catch (e, stackTrace) {
      print('❌ Error fetching product detail: $e');
      print('📍 Stack trace: $stackTrace');
      return null;
    }
  }
}
