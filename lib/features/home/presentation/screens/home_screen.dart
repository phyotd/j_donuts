import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:j_donuts/app/theme/app_colors.dart';
import 'package:j_donuts/core/utils/result.dart';
import 'package:go_router/go_router.dart';
import 'package:j_donuts/features/home/data/datasources/banner_mock_data.dart';
import 'package:j_donuts/features/home/presentation/widgets/banner_carousel.dart';
import 'package:j_donuts/features/products/presentation/providers/product_providers.dart';

// Import your existing auth notifier provider file.
import 'package:j_donuts/features/auth/presentation/providers/auth_notifier.dart';
import 'package:j_donuts/features/products/domain/entities/product.dart';
import 'package:j_donuts/features/products/presentation/widgets/product_skeleton_widget.dart';
import 'package:j_donuts/features/products/presentation/widgets/product_widget.dart';
import 'package:j_donuts/features/rewards/presentation/screens/rewards_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await ref.read(authNotifierProvider.notifier).logout();

    if (!mounted) return;

    if (result is Success<void>) {
      context.go('/onboarding');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    final firstName = authState.when(
      data: (user) => user?.firstName ?? 'Member',
      loading: () => 'Member',
      error: (_, _) => 'Member',
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _selectedIndex == 0
                ? _buildHomeTab(firstName)
                : _buildRewardsTab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }

  Widget _buildMemberHeader(String firstName) {
    return GestureDetector(
      onTap: _logout,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Bronze Member',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '1,290 points',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.verified, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab(String firstName) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (products) {
        final seasonalProducts = products
            .where((product) => product.isNew)
            .toList();

        final popularProducts = products
            .where((product) => product.isPopular)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMemberHeader(firstName),
              BannerCarousel(banners: BannerMockData.banners),
              const SizedBox(height: 24),
              _buildProductSection(
                title: 'Seasonal Specials',
                products: seasonalProducts,
                heroTagString: 'seasonal',
              ),
              const SizedBox(height: 24),
              _buildProductSection(title: 'Popular', products: popularProducts, heroTagString: 'popular'),
              const SizedBox(height: 24),
              _buildProductSection(title: 'All Donuts', products: products, heroTagString: 'all'),
            ],
          ),
        );
      },
      loading: () => _buildProductLoading(),
      error: (error, stackTrace) {
        return Center(child: Text('Something went wrong: $error'));
      },
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<Product> products,
    required String heroTagString,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('No products available'),
          )
        else
          SizedBox(
            height: 245,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 165,
                  child: ProductWidget(
                    product: products[index],
                    heroTag: '$heroTagString-${products[index].id}',
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int section = 0; section < 3; section++) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 245,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return const SizedBox(
                    width: 165,
                    child: ProductSkeletonWidget(),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRewardsTab() {
    return const RewardsScreen();
  }
}
