import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/user_model.dart';
import '../../models/service_model.dart';
import '../profile/profile_screen.dart';
import '../bookings/bookings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final user = authService.user;

        return Scaffold(
          backgroundColor: Colors.white,
          drawer: _buildDrawer(context, user, authService),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(context, user),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildPromoBanner(),
                  const SizedBox(height: 32),
                  _buildOurServicesHeader(),
                  const SizedBox(height: 16),
                  _buildServicesGrid(),
                  const SizedBox(height: 32),
                  _buildTrendingHeader(),
                  const SizedBox(height: 16),
                  _buildTrendingList(),
                  const SizedBox(height: 48), // Padding above bottom nav
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    UserModel? user,
    AuthService authService,
  ) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E659D), Color(0xFF33499E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: user?.photo != null
                          ? NetworkImage(user!.photo!)
                          : null,
                      child: user?.photo == null
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user?.fullName ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phoneNumber ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'My Booking',
                  onTap: () {
                    Navigator.pop(context);
                    // For now, push booking screen, though it's also in bottom nav
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BookingsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'My Wallet',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF6E7), // Light green tint
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '₹${user?.wallet.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Color(0xFF0F9D58),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Divider(color: Colors.grey[200]),
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.star_outline,
                  title: 'Rate Us On Store',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  showArrow: false,
                  onTap: () {
                    Navigator.pop(context);
                    authService.signOut();
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Version 2.4.1 (Build 108)',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor ?? const Color(0xFF2E659D),
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.grey[800],
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing:
          trailing ??
          (showArrow
              ? Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
              : null),
      onTap: onTap,
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FF), // Light blue tint
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF1D70F5),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'HOME',
                      style: TextStyle(
                        color: Color(0xFF1D70F5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF1D70F5),
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  user?.city ?? 'Set Location',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.black87,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: user?.photo != null
                        ? NetworkImage(user!.photo!)
                        : null,
                    child: user?.photo == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Text(
            'Search for sofa, tank, or carpet...',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          Container(
            height: 160,
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 160,
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurServicesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Our Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Row(
          children: [
            const Text(
              'View All',
              style: TextStyle(
                color: Color(0xFF1D70F5),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, color: Color(0xFF1D70F5), size: 14),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesGrid() {
    return FutureBuilder<List<ServiceModel>>(
      future: ApiService().getServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final services = snapshot.data ?? [];

        if (services.isEmpty) {
          if (snapshot.hasError) {
            return Text('Failed to load services: ${snapshot.error}');
          }
          return const Center(child: Text('No services available.'));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildServiceCard(services[index]);
          },
        );
      },
    );
  }

  Widget _buildServiceCard(ServiceModel service) {
    IconData icon = Icons.cleaning_services;
    Color iconColor = const Color(0xFF1D70F5);
    Color bgColor = const Color(0xFFF0F5FF);

    final lowerTitle = service.serviceTitle.toLowerCase();
    if (lowerTitle.contains('sofa')) {
      icon = Icons.weekend;
      iconColor = const Color(0xFF1D70F5);
      bgColor = const Color(0xFFF0F5FF);
    } else if (lowerTitle.contains('tank')) {
      icon = Icons.water_drop;
      iconColor = Colors.cyan;
      bgColor = Colors.cyan[50]!;
    } else if (lowerTitle.contains('carpet')) {
      icon = Icons.layers;
      iconColor = Colors.deepPurple;
      bgColor = Colors.deepPurple[50]!;
    } else if (lowerTitle.contains('washroom')) {
      icon = Icons.clean_hands;
      iconColor = Colors.pink;
      bgColor = Colors.pink[50]!;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Text(
            service.serviceTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            'From ₹${service.actualAmount.toStringAsFixed(0)}',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Trending Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF1D70F5),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendingList() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildTrendingCard(
            title: 'Full Kitchen Deep Cleaning',
            subtitle: 'Chimney + Cabinets + Floor',
            price: '1,299',
            rating: '4.8',
            imageColor: const Color(
              0xFFDED3C4,
            ), // A beige representation for the kitchen
          ),
          const SizedBox(width: 16),
          _buildTrendingCard(
            title: 'Premium Bathroom Cleaning',
            subtitle: 'Hard water stains removal',
            price: '599',
            rating: '4.9',
            imageColor: const Color(0xFFA1BFA8), // A sage green representation
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard({
    required String title,
    required String subtitle,
    required String price,
    required String rating,
    required Color imageColor,
  }) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: imageColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1D70F5),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Color(0xFF1D70F5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
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
}
