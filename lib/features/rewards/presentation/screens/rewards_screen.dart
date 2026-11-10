
import 'package:flutter/material.dart';
import 'package:j_donuts/app/theme/app_colors.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Donut\'s Rewards'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPointsCard(),
            const SizedBox(height: 24),
            _buildMembershipTiers(),
            const SizedBox(height: 24),
            _buildBenefits(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BRONZE MEMBER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Icon(Icons.card_giftcard, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Your Points',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          const Text(
            '1,290',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Progress to Silver',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: 9,
              backgroundColor: Colors.white30,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep collecting points to reach the next tier!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipTiers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membership Tiers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildTierItem(
          title: 'Bronze',
          subtitle: 'Current membership',
          icon: Icons.workspace_premium,
          color: Colors.brown,
          isCurrent: true,
        ),
        _buildTierItem(
          title: 'Silver',
          subtitle: 'Unlock more exclusive benefits',
          icon: Icons.workspace_premium,
          color: Colors.blueGrey,
        ),
        _buildTierItem(
          title: 'Gold',
          subtitle: 'Enjoy premium member benefits',
          icon: Icons.workspace_premium,
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildTierItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isCurrent = false,
  }) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: isCurrent
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : const Icon(Icons.lock_outline, color: Colors.grey),
      ),
    );
  }

  Widget _buildBenefits() {
    final benefits = [
      'Earn points with every purchase',
      'Access exclusive member promotions',
      'Receive birthday rewards',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Member Benefits',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.surface,
          child: Column(
            children: benefits.map((benefit) {
              return ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                ),
                title: Text(benefit),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
