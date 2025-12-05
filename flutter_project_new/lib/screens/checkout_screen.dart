import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/cart.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import '../services/raja_ongkir_service.dart';
import '../models/raja_ongkir/province.dart';
import '../models/raja_ongkir/city.dart';
import '../models/raja_ongkir/shipping_cost.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedPaymentMethod = 'midtrans';
  String _selectedPaymentType = 'penuh'; // 'penuh' atau 'dp'
  int? _selectedShippingId;
  int? _selectedDiscountId;
  bool _isLoading = false;

  // Raja Ongkir state
  List<Province> _provinces = [];
  List<City> _originCities = [];
  List<City> _destinationCities = [];
  City? _selectedOriginCity;
  City? _selectedDestinationCity;
  String? _selectedCourier;
  List<ShippingCost> _shippingCosts = [];
  Cost? _selectedShippingCost;
  bool _isLoadingCities = false;
  bool _isLoadingShippingCost = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
    // Set default origin city (contoh: Jakarta)
    _loadOriginCities();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadProvinces() async {
    try {
      // Backend sekarang mencari berdasarkan nama, jadi kita muat beberapa provinsi umum.
      // Atau bisa juga menggunakan input search dari user.
      final provinces = await RajaOngkirService.getProvinces(
        'jakarta',
      ); // Contoh: cari provinsi yg mengandung "jakarta"
      setState(() {
        _provinces = provinces;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat provinsi: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _loadOriginCities() async {
    // Default origin: Jakarta
    setState(() {
      _isLoadingCities = true;
    });
    try {
      final cities = await RajaOngkirService.getCities('jakarta');

      // Debug log
      print('🏙️ Origin cities loaded: ${cities.length}');
      for (var city in cities) {
        print('  - ${city.cityName} (ID: ${city.cityId})');
      }

      setState(() {
        _originCities = cities;

        // Set default origin - gunakan first() jika ada, atau jangan set sama sekali
        if (cities.isNotEmpty) {
          // Cari Jakarta Pusat, jika tidak ada gunakan yang pertama
          try {
            _selectedOriginCity = cities.firstWhere(
              (city) => city.cityName.toLowerCase().contains('jakarta pusat'),
            );
          } catch (e) {
            // Jika tidak ketemu, gunakan yang pertama saja
            _selectedOriginCity = cities.first;
          }
          print('✅ Selected origin city: ${_selectedOriginCity?.cityName}');
        } else {
          print('⚠️ No cities found for search term "jakarta"');
          _selectedOriginCity = null;
        }
      });
    } catch (e) {
      print('❌ Error loading origin cities: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kota asal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _loadDestinationCities(String provinceName) async {
    setState(() {
      _isLoadingCities = true;
      _destinationCities = [];
      _selectedDestinationCity = null;
    });

    // Jangan panggil API jika nama provinsi kosong.
    if (provinceName.trim().isEmpty) {
      setState(() => _isLoadingCities = false);
      return;
    }
    try {
      // Backend now uses search by name, not province_id
      final cities = await RajaOngkirService.getCities(provinceName);
      setState(() {
        _destinationCities = cities;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat kota tujuan: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _calculateShippingCost() async {
    if (_selectedOriginCity == null ||
        _selectedDestinationCity == null ||
        _selectedCourier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kota asal, tujuan, dan kurir terlebih dahulu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoadingShippingCost = true;
      _shippingCosts = [];
      _selectedShippingCost = null;
    });

    try {
      // Calculate weight from cart items (default 1000g per item if not specified)
      int totalWeight = widget.cart.totalItems * 1000; // grams

      final costs = await RajaOngkirService.calculateShippingCost(
        origin: _selectedOriginCity!.cityId,
        destination: _selectedDestinationCity!.cityId,
        weight: totalWeight,
        courier: _selectedCourier!,
      );

      setState(() {
        _shippingCosts = costs;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghitung ongkir: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingShippingCost = false;
      });
    }
  }

  int get _totalPriceWithShipping {
    int basePrice = widget.cart.totalPrice.toInt();
    int shippingCost = _selectedShippingCost?.totalCost ?? 0;
    return basePrice + shippingCost;
  }

  Future<void> _processCheckout() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Build order items payload
      // Map cart items to API format with varian_id & jumlah
      List<Map<String, dynamic>> orderItems = [];

      for (var item in widget.cart.items) {
        // Check if item has varian_id (for regular products)
        if (item.varianId != null) {
          orderItems.add({
            'varian_id': item.varianId,
            'jumlah': item.totalQuantity,
          });
        }
        // Note: Custom orders without varian_id should be handled separately
        // via /api/custom-order endpoint after creating the base order
      }

      // If no valid items, show error
      if (orderItems.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tidak ada item yang valid untuk checkout. Pastikan item memiliki varian_id.',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Prepare ongkir data if selected
      String? kurir;
      String? layanan;
      int? hargaOngkir;
      String? estimasi;

      if (_selectedShippingCost != null && _selectedCourier != null) {
        // Get courier name
        final courierList = RajaOngkirService.getAvailableCouriers();
        final courierMap = courierList.firstWhere(
          (c) => c['code'] == _selectedCourier,
          orElse: () => <String, String>{
            'code': _selectedCourier!,
            'name': _selectedCourier!.toUpperCase(),
          },
        );
        kurir = courierMap['name'] ?? _selectedCourier!.toUpperCase();
        layanan = _selectedShippingCost!.service;
        hargaOngkir = _selectedShippingCost!.totalCost;
        estimasi = _selectedShippingCost!.etd.isNotEmpty
            ? '${_selectedShippingCost!.etd} hari'
            : null;
      }

      // Create order
      final orderData = await OrderService.createOrder(
        items: orderItems,
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
        tipePembayaran: _selectedPaymentMethod == 'midtrans'
            ? _selectedPaymentType
            ? _selectedPaymentType // Kirim 'penuh' atau 'dp'
            : null, // Kirim tipe pembayaran jika Midtrans
        shippingCostId: _selectedShippingId,
        discountId: _selectedDiscountId,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        // Data ongkir dari Raja Ongkir
        kurir: kurir,
        layanan: layanan,
        hargaOngkir: hargaOngkir,
        estimasi: estimasi,
      );

      // Handle payment response
      final payment = orderData['payment'] as Map<String, dynamic>?;

      print('💳 Payment response: $payment');

      if (payment != null && _selectedPaymentMethod == 'midtrans') {
        String? snapRedirectUrl = payment['snap_redirect_url'] as String?;
        final snapToken = payment['snap_token'] as String?;

        print('🔗 Snap redirect URL: $snapRedirectUrl');
        print(
          '🎫 Snap token: ${snapToken != null ? "Token tersedia" : "Token tidak ada"}',
        );

        // Jika tidak ada redirect_url, buat URL dari snap_token
        // Midtrans menggunakan format /snap/v4/redirection/ untuk versi terbaru
        if ((snapRedirectUrl == null || snapRedirectUrl.isEmpty) &&
            snapToken != null) {
          final environment = payment['environment'] as String? ?? 'sandbox';
          final baseUrl = environment == 'production'
              ? 'https://app.midtrans.com'
              : 'https://app.sandbox.midtrans.com';
          // Gunakan format v4 yang lebih baru
          snapRedirectUrl = '$baseUrl/snap/v4/redirection/$snapToken';
          print('🔗 Generated redirect URL: $snapRedirectUrl');
        }

        if (snapRedirectUrl != null && snapRedirectUrl.isNotEmpty) {
          // Launch Midtrans payment
          print('🚀 Launching Midtrans payment...');
          try {
            // Launch payment URL
            await PaymentService.launchSnapUrl(snapRedirectUrl);

            if (mounted) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Halaman pembayaran Midtrans dibuka. Silakan selesaikan pembayaran.',
                  ),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 2),
                ),
              );

              // Navigate back to home after a short delay to allow payment page to open
              await Future.delayed(const Duration(milliseconds: 500));

              if (mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
          } catch (e) {
            print('❌ Error launching Midtrans: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal membuka halaman pembayaran: $e'),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        } else {
          // No redirect URL atau token - error
          print('❌ No snap redirect URL or token available');
          print('📋 Payment data: $payment');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Gagal membuat pembayaran Midtrans. Pastikan MIDTRANS_SERVER_KEY dan MIDTRANS_CLIENT_KEY sudah dikonfigurasi di server.',
                ),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } else {
        // COD or other payment method
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Pesanan berhasil dibuat. Silakan tunggu konfirmasi.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      print('Error during checkout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat pesanan: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
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
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.borderColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummary(),
              const SizedBox(height: 24),
              _buildShippingAddress(),
              const SizedBox(height: 24),
              _buildRajaOngkirSection(),
              const SizedBox(height: 24),
              _buildPaymentMethod(),
              const SizedBox(height: 24),
              _buildNotes(),
              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Item',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${widget.cart.totalItems} pcs',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Rp ${widget.cart.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (_selectedShippingCost != null) ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ongkir',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Rp ${_selectedShippingCost!.totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Harga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp ${_totalPriceWithShipping.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alamat Pengiriman',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: 'Masukkan alamat lengkap pengiriman',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Alamat pengiriman wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRajaOngkirSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Ongkos Kirim (Raja Ongkir)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Origin City - Perbaikan: hapus initialValue jika null
          if (_originCities.isNotEmpty)
            DropdownButtonFormField<City>(
              value: _selectedOriginCity,
              decoration: const InputDecoration(
                labelText: 'Kota Asal',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _originCities.map((city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.displayName),
                );
              }).toList(),
              onChanged: (city) {
                setState(() {
                  _selectedOriginCity = city;
                  _shippingCosts = [];
                  _selectedShippingCost = null;
                });
              },
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Memuat kota asal...',
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          const SizedBox(height: 16),
          // Destination Province
          if (_provinces.isNotEmpty)
            DropdownButtonFormField<Province>(
              value: null,
              decoration: InputDecoration(
                labelText: 'Provinsi Tujuan',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.map),
                suffixIcon: _isLoadingCities
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              items: _provinces.map((province) {
                return DropdownMenuItem<Province>(
                  value: province,
                  child: Text(province.province),
                );
              }).toList(),
              onChanged: (province) {
                if (province != null) {
                  _loadDestinationCities(province.province);
                }
              },
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Memuat provinsi...',
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          const SizedBox(height: 16),
          // Destination City - Perbaikan: cek jika _destinationCities tidak kosong
          if (_destinationCities.isNotEmpty)
            DropdownButtonFormField<City>(
              value: _selectedDestinationCity,
              decoration: const InputDecoration(
                labelText: 'Kota Tujuan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _destinationCities.map((city) {
                return DropdownMenuItem<City>(
                  value: city,
                  child: Text(city.displayName),
                );
              }).toList(),
              onChanged: (city) {
                setState(() {
                  _selectedDestinationCity = city;
                  _shippingCosts = [];
                  _selectedShippingCost = null;
                });
              },
            )
          else if (_isLoadingCities)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Pilih provinsi terlebih dahulu...',
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          const SizedBox(height: 16),
          // Courier Selection
          DropdownButtonFormField<String>(
            value: _selectedCourier,
            decoration: const InputDecoration(
              labelText: 'Pilih Kurir',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.delivery_dining),
            ),
            items: RajaOngkirService.getAvailableCouriers().map((courier) {
              return DropdownMenuItem<String>(
                value: courier['code'],
                child: Text(courier['name'] ?? ''),
              );
            }).toList(),
            onChanged: (courier) {
              setState(() {
                _selectedCourier = courier;
                _shippingCosts = [];
                _selectedShippingCost = null;
              });
            },
          ),
          const SizedBox(height: 16),
          // Calculate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  (_selectedOriginCity != null &&
                      _selectedDestinationCity != null &&
                      _selectedCourier != null &&
                      !_isLoadingShippingCost)
                  ? _calculateShippingCost
                  : null,
              icon: _isLoadingShippingCost
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.calculate),
              label: const Text('Hitung Ongkir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Shipping Cost Options
          if (_shippingCosts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              'Pilih Layanan Pengiriman:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._shippingCosts.expand((shippingCost) {
              return shippingCost.costs.map((cost) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedShippingCost == cost
                          ? AppColors.primary
                          : AppColors.borderColor,
                      width: _selectedShippingCost == cost ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: _selectedShippingCost == cost
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                  ),
                  child: RadioListTile<Cost>(
                    title: Text(
                      '${shippingCost.name} - ${cost.service}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cost.description),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${cost.totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (cost.etd.isNotEmpty)
                          Text(
                            'Estimasi: ${cost.etd} hari',
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    value: cost,
                    groupValue: _selectedShippingCost,
                    onChanged: (value) {
                      setState(() {
                        _selectedShippingCost = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                );
              });
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            title: const Text('Midtrans (Transfer Bank, E-Wallet, dll)'),
            subtitle: const Text('Pembayaran online via Midtrans'),
            value: 'midtrans',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            activeColor: AppColors.primary,
          ),
          RadioListTile<String>(
            title: const Text('COD (Cash on Delivery)'),
            subtitle: const Text('Bayar saat barang diterima'),
            value: 'cod',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
            activeColor: AppColors.primary,
          ),
          // Opsi DP jika Midtrans dipilih
          if (_selectedPaymentMethod == 'midtrans') ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Opsi Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  RadioListTile<String>(
                    title: const Text('Bayar Penuh'),
                    value: 'penuh',
                    groupValue: _selectedPaymentType,
                    onChanged: (v) => setState(() => _selectedPaymentType = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Down Payment (DP) 50%'),
                    value: 'dp',
                    groupValue: _selectedPaymentType,
                    onChanged: (v) => setState(() => _selectedPaymentType = v!),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotes() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              hintText: 'Tambahkan catatan untuk pesanan Anda',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 3,
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp ${_totalPriceWithShipping.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
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
              onPressed: _isLoading ? null : _processCheckout,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Text(
                      'Buat Pesanan',
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
}
