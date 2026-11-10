import 'package:flutter/material.dart';
import 'package:j_donuts/app/theme/app_colors.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPointsCard(),
          const SizedBox(height: 24),
          const Text(
            'How to earn points',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildEarnPointsItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Purchase donuts',
            description: 'Earn points with every purchase.',
          ),
          _buildEarnPointsItem(
            icon: Icons.cake_outlined,
            title: 'Birthday reward',
            description: 'Enjoy a special birthday reward.',
          ),
          _buildEarnPointsItem(
            icon: Icons.card_giftcard_outlined,
            title: 'Redeem rewards',
            description: 'Use your points to get special rewards.',
          ),
        ],
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'My Points',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Available points',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnPointsItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }
}