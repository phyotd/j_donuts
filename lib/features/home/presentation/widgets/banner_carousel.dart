import 'package:flutter/material.dart';
import 'package:j_donuts/app/theme/app_colors.dart';
import 'package:j_donuts/features/home/domain/entities/banner.dart';

class BannerCarousel extends StatefulWidget {
  final List<AppBanner> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryLight,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.55),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            final isSelected = index == _currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}
