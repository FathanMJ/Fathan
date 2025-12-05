import 'package:flutter/material.dart';
import 'laravel_api_service.dart';
import '../screens/material_model.dart';

class MasterDataService {
  // Get all materials
  static Future<List<MaterialModel>> getMaterials() async {
    try {
      final response = await LaravelApiService.get('/materials', requiresAuth: false);
      final materialsData = response['data'] ?? [];
      
      return materialsData.map<MaterialModel>((item) {
        return MaterialModel(
          id: item['id'],
          name: item['nama'] ?? '',
          description: item['deskripsi'] ?? '',
          priceIncrease: _formatPrice(item['harga_tambahan']),
          priceIncreaseValue: _parsePrice(item['harga_tambahan']),
          imageUrl: (item['foto'] is String && (item['foto'] as String).isNotEmpty)
              ? item['foto']
              : null,
        );
      }).toList();
    } catch (e) {
      print('Error fetching materials: $e');
      return [];
    }
  }

  // Get all collar types
  static Future<List<Map<String, dynamic>>> getCollarTypes() async {
    try {
      final response = await LaravelApiService.get('/collar-types', requiresAuth: false);
      final collarTypesData = response['data'] ?? [];
      
      return collarTypesData.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'],
          'type': item['nama'] ?? '',
          'description': _getCollarDescription(item['nama'] ?? ''),
          'priceAdjustment': _parsePrice(item['harga_tambahan']),
          'iconData': _getCollarIcon(item['nama'] ?? ''),
          'applicable': ['Kaos', 'T-Shirt', 'Polo', 'Jersey'],
          'image': (item['foto'] is String && (item['foto'] as String).isNotEmpty) ? item['foto'] : null,
        };
      }).toList();
    } catch (e) {
      print('Error fetching collar types: $e');
      return [];
    }
  }

  // Get all sleeve lengths
  static Future<List<Map<String, dynamic>>> getSleeveLengths() async {
    try {
      final response = await LaravelApiService.get('/sleeve-lengths', requiresAuth: false);
      final sleeveLengthsData = response['data'] ?? [];
      
      return sleeveLengthsData.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'],
          'length': item['nama'] ?? '',
          'description': _getSleeveDescription(item['nama'] ?? ''),
          'priceAdjustment': _parsePrice(item['harga_tambahan']),
          'iconData': _getSleeveIcon(item['nama'] ?? ''),
          'applicable': ['Kaos', 'T-Shirt', 'Polo', 'Hoodie', 'Kemeja', 'Jersey'],
          'image': (item['foto'] is String && (item['foto'] as String).isNotEmpty) ? item['foto'] : null,
        };
      }).toList();
    } catch (e) {
      print('Error fetching sleeve lengths: $e');
      return [];
    }
  }

  // Get all size types
  static Future<List<Map<String, dynamic>>> getSizeTypes() async {
    try {
      final response = await LaravelApiService.get('/size-types', requiresAuth: false);
      final sizeTypesData = response['data'] ?? [];
      
      return sizeTypesData.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'] ?? item['id_jenis_ukuran'],
          'name': item['nama'] ?? '',
          'priceAdjustment': _parsePrice(item['harga_tambahan']),
        };
      }).toList();
    } catch (e) {
      print('Error fetching size types: $e');
      return [];
    }
  }

  // Get all size details (ukuran detail)
  static Future<List<Map<String, dynamic>>> getSizeDetails() async {
    try {
      final response = await LaravelApiService.get('/size-details', requiresAuth: false);
      final sizeDetailsData = response['data'] ?? [];
      
      return sizeDetailsData.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'] ?? item['id_ukuran_detail'],
          'name': item['nama'] ?? '',
          'priceAdjustment': _parsePrice(item['harga_tambahan']),
        };
      }).toList();
    } catch (e) {
      print('Error fetching size details: $e');
      return [];
    }
  }

  // Get all colors (warna)
  static Future<List<Map<String, dynamic>>> getWarna() async {
    try {
      final response = await LaravelApiService.get('/warna', requiresAuth: false);
      final warnasData = response['data'] ?? [];
      
      return warnasData.map<Map<String, dynamic>>((item) {
        return {
          'id': item['id'] ?? item['id_warna'],
          'nama': item['nama'] ?? '',
          'kode_hex': item['kode_hex'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching warna: $e');
      return [];
    }
  }

  // Helper methods
  static int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is int) return price;
    if (price is double) return price.toInt();
    if (price is String) {
      final parsed = double.tryParse(price);
      return parsed?.toInt() ?? 0;
    }
    return 0;
  }

  static String _formatPrice(dynamic price) {
    final priceValue = _parsePrice(price);
    if (priceValue > 0) {
      return '+ Rp ${priceValue.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    }
    return '+ Rp 0';
  }

  static String _getCollarDescription(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('o-neck') || lower.contains('round')) {
      return 'Kerah bulat standar';
    } else if (lower.contains('v-neck') || lower.contains('v')) {
      return 'Kerah berbentuk V';
    } else if (lower.contains('polo')) {
      return 'Kerah polo dengan kancing';
    } else if (lower.contains('henley')) {
      return 'Kerah dengan beberapa kancing';
    }
    return 'Kerah standar';
  }

  static IconData _getCollarIcon(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('o-neck') || lower.contains('round')) {
      return Icons.circle_outlined;
    } else if (lower.contains('v-neck') || lower.contains('v')) {
      return Icons.change_history;
    } else if (lower.contains('polo')) {
      return Icons.sports_esports;
    } else if (lower.contains('henley')) {
      return Icons.more_horiz;
    }
    return Icons.circle_outlined;
  }

  static String _getSleeveDescription(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('pendek') || lower.contains('short')) {
      return 'Standard tanpa tambahan biaya';
    } else if (lower.contains('panjang') || lower.contains('long')) {
      return 'Dengan tambahan biaya untuk kenyamanan ekstra';
    } else if (lower.contains('tanpa') || lower.contains('sleeveless')) {
      return 'Sleeveless atau tank top';
    }
    return 'Panjang lengan standar';
  }

  static IconData _getSleeveIcon(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('pendek') || lower.contains('short')) {
      return Icons.accessibility_new;
    } else if (lower.contains('panjang') || lower.contains('long')) {
      return Icons.checkroom;
    } else if (lower.contains('tanpa') || lower.contains('sleeveless')) {
      return Icons.whatshot;
    }
    return Icons.checkroom;
  }
}
