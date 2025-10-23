import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'constants/colors.dart';
import 'screens/custom_order_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/page_transitions.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenBody(),
    Text('Cari'), // Placeholder for Search Screen
    Text('Disimpan'), // Placeholder for Saved Screen
    Text('Keranjang'), // Placeholder for Cart Screen
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildAnimatedIcon(IconData unselectedIcon, IconData selectedIcon, int index) {
    final isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          key: ValueKey(isSelected),
          size: isSelected ? 26 : 24,
          color: isSelected ? AppColors.primary : AppColors.textLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.home_outlined, Icons.home, 0),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.search_outlined, Icons.search, 1),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.favorite_border, Icons.favorite, 2),
              label: 'Disimpan',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.shopping_bag_outlined, Icons.shopping_bag, 3),
              label: 'Keranjang',
            ),
            BottomNavigationBarItem(
              icon: _buildAnimatedIcon(Icons.person_outline, Icons.person, 4),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final List<String> _promoBanners = [
    'https://placehold.co/600x200/FF5252/FFFFFF?text=PROMO+AKHIR+TAHUN',
    'https://placehold.co/600x200/5252FF/FFFFFF?text=DISKON+SEMUA+PRODUK',
    'https://placehold.co/600x200/FFD700/000000?text=GRATIS+ONGKIR',
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Regular Fit Slagan',
      'price': 'Rp 179.000',
      'image': 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
    },
    {
      'name': 'Regular Fit Polo',
      'price': 'Rp 1.100.000',
      'discounted_price': 'Rp 520.000',
      'image': 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
    },
    {
      'name': 'Regular Fit Black',
      'price': 'Rp 169.000',
      'image': 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
    },
    {
      'name': 'Regular Fit V-Neck',
      'price': 'Rp 129.000',
      'image': 'https://instagram.fcgk34-1.fna.fbcdn.net/v/t51.2885-15/495847179_18402765463111437_2907903918493001001_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkZFRUQuaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UuYzIifQ&_nc_ht=instagram.fcgk34-1.fna.fbcdn.net&_nc_cat=109&_nc_oc=Q6cZ2QGDDKtHgIUwCjAy4YgvYrovAv-eKiJt2gkfPFoQ509H-qGCNW3ZoI4NVPpEG86PPGE&_nc_ohc=br8qiFZp9isQ7kNvwHzOCKO&_nc_gid=Q-fYY76dLRTJt6MJTclv_g&edm=APoiHPcBAAAA&ccb=7-5&ig_cache_key=MzYyNTczMjA1MDkyNzY3NjM3Mg%3D%3D.3-ccb7-5&oh=00_AfY8wXUgewG_oX7bGas7KcvHHXZVGP8SAr2HAWZrf3yjKQ&oe=68DA8473&_nc_sid=22de04',
    },
  ];

  final List<Map<String, dynamic>> _customTemplates = [
    {
      'name': 'T-Shirt Polos',
      'image':
          'https://placehold.co/600x400/FFFFFF/000000?text=T-Shirt+Template',
      'variants': ['Lengan Pendek', 'Lengan Panjang'],
      'minPrice': 'Rp 89.000',
    },
    {
      'name': 'Polo Shirt',
      'image': 'https://placehold.co/600x400/FFFFFF/000000?text=Polo+Template',
      'variants': ['Regular Fit', 'Slim Fit'],
      'minPrice': 'Rp 129.000',
    },
    {
      'name': 'Hoodie',
      'image':
          'https://placehold.co/600x400/FFFFFF/000000?text=Hoodie+Template',
      'variants': ['Dengan Resleting', 'Tanpa Resleting'],
      'minPrice': 'Rp 199.000',
    },
  ];

  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;
  bool _isAutoSlideEnabled = true;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    if (!_isAutoSlideEnabled) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      setState(() {
        if (_currentPage < _promoBanners.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _stopAutoSlide() {
    _timer?.cancel();
    _timer = null;
  }

  void _toggleAutoSlide() {
    setState(() {
      _isAutoSlideEnabled = !_isAutoSlideEnabled;
      if (_isAutoSlideEnabled) {
        _startAutoSlide();
      } else {
        _stopAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.text),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hi, Andy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.shopping_cart_outlined,
                  notificationCount: 2,
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.notifications_outlined,
                  notificationCount: 3,
                  onPressed: () {},
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  notificationCount: 1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CustomPageTransitions.slideFromRight(
                        const ChatListScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildPromoBanner(),
            _buildCategories(),
            _buildSectionTitle('Produk Unggulan'),
            _buildProductGrid(),
            _buildCustomOrderSection(),
            _buildSectionTitle('Produk Diskon'),
            _buildDiscountedProducts(),
            _buildOrderTrackingSection(),
            _buildRecentOrdersSection(),
            _buildStoreInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                CustomPageTransitions.slideFromBottom(
                  const ChatListScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
              child: const Icon(
                Icons.chat,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildDrawerHeader(),
                  _buildDrawerMenuItem(
                    icon: Icons.design_services_outlined,
                    title: 'Custom Order',
                    subtitle: 'Buat jersey tim custom',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CustomPageTransitions.slideFromBottom(
                          const CustomOrderScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Katalog Produk',
                    subtitle: 'Lihat semua produk',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.history,
                    title: 'Riwayat Pesanan',
                    subtitle: 'Lihat pesanan sebelumnya',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Wishlist',
                    subtitle: 'Item yang disimpan',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Tracking Pesanan',
                    subtitle: 'Cek status pengiriman',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.support_agent,
                    title: 'Bantuan',
                    subtitle: 'Hubungi customer service',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Kami',
                    subtitle: 'Info tentang Muara Project',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.sports_soccer,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
              'Muara Project',
              style: TextStyle(
                color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jersey Tim Custom Berkualitas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Andy Pratama',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'andy@email.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int notificationCount = 0,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: IconButton(
            icon: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon, 
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                if (notificationCount > 0)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, scaleValue, child) {
                      return Transform.scale(
                        scale: scaleValue,
                        child: Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari jersey, kaos, atau produk...',
                hintStyle: TextStyle(color: AppColors.textLight),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: AppColors.accent,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryPill('All', true),
          _buildCategoryPill('Tshirts', false),
          _buildCategoryPill('Jeans', false),
          _buildCategoryPill('Shoes', false),
          // Tambahkan kategori lain
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                // Restart timer when manually changed
                _stopAutoSlide();
                _startAutoSlide();
              });
            },
            itemCount: _promoBanners.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _toggleAutoSlide,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(_promoBanners[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _promoBanners.length,
                (index) => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    final isActive = _currentPage == index;
                    return Transform.scale(
                      scale: isActive ? value : 1.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 12 : 8,
                        height: isActive ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.white.withOpacity(0.5),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(
            name: product['name']!,
            price: product['price']!,
            image: product['image']!,
            discountedPrice: product['discounted_price'],
          );
        },
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String price,
    required String image,
    String? discountedPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Stack(
              children: [
                ClipRRect(
              borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
              ),
              child: Image.network(
                image,
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
                if (discountedPrice != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DISKON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.text,
                ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                if (discountedPrice != null)
                  Text(
                    price,
                    style: TextStyle(
                            fontSize: 11,
                      color: Colors.grey[600],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                Text(
                  discountedPrice ?? price,
                        style: TextStyle(
                    fontWeight: FontWeight.bold,
                          color: discountedPrice != null
                              ? AppColors.accent
                              : AppColors.primary,
                          fontSize: 13,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildCustomOrderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Template Custom Desain',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomOrderScreen(),
                    ),
                  );
                },
                child: const Text('Lanjut Custom'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _customTemplates.length,
              itemBuilder: (context, index) {
                final template = _customTemplates[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          template['image'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mulai dari ${template['minPrice']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountedProducts() {
    // Implementasi untuk menampilkan produk diskon
    return Container();
  }

  Widget _buildOrderTrackingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pesanan Terakhir',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatus(Icons.shopping_basket, 'Diproses'),
              _buildOrderStatus(Icons.local_shipping, 'Dikirim'),
              _buildOrderStatus(Icons.check_circle, 'Selesai'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(IconData icon, String status) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(status, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentOrdersSection() {
    // Implementasi untuk menampilkan pesanan terbaru
    return Container();
  }

  Widget _buildStoreInfo() {
    // Implementasi untuk menampilkan informasi toko
    return Container();
  }
}

class WavyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..isAntiAlias = true;

    final double left = 0;
    final double right = size.width;
    final double topOffset = 60;
    final double spacing = 28;

    for (int i = 0; i < 4; i++) {
      final Path path = Path();
      final double dy = topOffset + i * spacing;
      path.moveTo(left, dy);

      // create 3 bezier segments forming a smooth wave
      path.cubicTo(
        right * 0.15,
        dy - 10 - i * 6,
        right * 0.35,
        dy + 40 + i * 6,
        right * 0.5,
        dy + 20 + i * 4,
      );
      path.cubicTo(
        right * 0.65,
        dy - 4 - i * 4,
        right * 0.85,
        dy + 40 + i * 6,
        right,
        dy + 28 - i * 2,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
