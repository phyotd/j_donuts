import '../../domain/entities/banner.dart';

class BannerMockData {
  static const List<AppBanner> banners = [
    AppBanner(
      id: 'banner_1',
      imageUrl: 'assets/images/banners/banner_1.png',
      title: 'Fresh Donuts, Every Day',
      subtitle: 'Enjoy your favorite treats!',
    ),
    AppBanner(
      id: 'banner_2',
      imageUrl: 'assets/images/banners/banner_2.png',
      title: 'Sweet Moments',
      subtitle: 'Make every moment sweeter.',
    ),
    AppBanner(
      id: 'banner_3',
      imageUrl: 'assets/images/banners/banner_3.png',
      title: 'Special Offers',
      subtitle: 'Discover something delicious.',
    ),
  ];
}