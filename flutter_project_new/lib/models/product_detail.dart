import '../config/api_config.dart';

class ProductVariant {
  final int idVarian;
  final int produkId;
  final double hargaTambahan;
  final int stok;
  final String? ukuranDetailNama;
  final int? ukuranDetailId;
  final String? materialNama;
  final int? materialId;

  ProductVariant({
    required this.idVarian,
    required this.produkId,
    required this.hargaTambahan,
    required this.stok,
    this.ukuranDetailNama,
    this.ukuranDetailId,
    this.materialNama,
    this.materialId,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    // Parse harga_tambahan - handle both string and numeric values
    double hargaTambahan = 0.0;
    if (json['harga_tambahan'] != null) {
      if (json['harga_tambahan'] is String) {
        hargaTambahan = double.tryParse(json['harga_tambahan']) ?? 0.0;
      } else if (json['harga_tambahan'] is num) {
        hargaTambahan = (json['harga_tambahan'] as num).toDouble();
      }
    }
    
    return ProductVariant(
      idVarian: json['id_varian'] ?? 0,
      produkId: json['produk_id'] ?? 0,
      hargaTambahan: hargaTambahan,
      stok: json['stok'] ?? 0,
      ukuranDetailNama: json['ukuran_detail']?['nama'],
      ukuranDetailId: json['ukuran_detail']?['id_ukuran_detail'],
      materialNama: json['material']?['nama'],
      materialId: json['material']?['id_material'],
    );
  }
}

class ProductDetail {
  final int id;
  final String nama;
  final String deskripsi;
  final double? hargaDasar;
  final String? tipeProduk; // 'biasa' or 'custom'
  final int? stok; // Total stok untuk produk biasa
  final List<String> imageUrls;
  final List<ProductVariant> varian;
  final String? kategoriNama;
  final int? kategoriId;

  ProductDetail({
    required this.id,
    required this.nama,
    required this.deskripsi,
    this.hargaDasar,
    this.tipeProduk,
    this.stok,
    required this.imageUrls,
    required this.varian,
    this.kategoriNama,
    this.kategoriId,
  });

  bool get isBiasa => tipeProduk == 'biasa';
  bool get isCustom => tipeProduk == 'custom';

  // Get total stock for biasa products
  int get totalStok {
    if (isBiasa) {
      return varian.fold(0, (sum, v) => sum + v.stok);
    }
    return stok ?? 0;
  }

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    // Parse images
    List<String> images = [];
    if (json['fotos'] != null && json['fotos'] is List) {
      for (var foto in json['fotos']) {
        if (foto['nama_file'] != null && foto['nama_file'].toString().isNotEmpty) {
          String fotoPath = foto['nama_file'].toString();
          if (fotoPath.startsWith('public/')) {
            fotoPath = fotoPath.replaceFirst('public/', '');
          }
          // Base URL without /api
          String baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
          final imageUrl = '$baseUrl/storage/$fotoPath';
          if (imageUrl.isNotEmpty) {
            images.add(imageUrl);
          }
        }
      }
    }

    // Parse variants
    List<ProductVariant> variants = [];
    if (json['varian'] != null && json['varian'] is List) {
      variants = (json['varian'] as List)
          .map((v) => ProductVariant.fromJson(v))
          .toList();
    }

    // Parse harga_dasar
    double? hargaDasar;
    if (json['harga_dasar'] != null) {
      if (json['harga_dasar'] is String) {
        hargaDasar = double.tryParse(json['harga_dasar']);
      } else if (json['harga_dasar'] is num) {
        hargaDasar = (json['harga_dasar'] as num).toDouble();
      }
    }

    // Parse id - handle both id_produk and id, ensure it's not null
    int? parsedId;
    if (json['id_produk'] != null) {
      parsedId = json['id_produk'] is int ? json['id_produk'] : int.tryParse(json['id_produk'].toString());
    } else if (json['id'] != null) {
      parsedId = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    }
    
    if (parsedId == null) {
      throw Exception('Product ID is required but not found in response');
    }

    return ProductDetail(
      id: parsedId,
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      hargaDasar: hargaDasar,
      tipeProduk: json['tipe_produk'],
      stok: json['stok'] is int ? json['stok'] : (json['stok'] != null ? int.tryParse(json['stok'].toString()) : null),
      imageUrls: images,
      varian: variants,
      kategoriNama: json['kategori']?['nama'],
      kategoriId: () {
        final kategoriIdValue = json['kategori']?['id_kategori'];
        if (kategoriIdValue == null) return null;
        if (kategoriIdValue is int) return kategoriIdValue;
        return int.tryParse(kategoriIdValue.toString());
      }(),
    );
  }
}

