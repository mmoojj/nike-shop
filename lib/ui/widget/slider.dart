import 'package:flutter/material.dart';
import 'package:nike_shop/common/utils.dart';
import 'package:nike_shop/data/banner.dart';
import 'package:nike_shop/ui/widget/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerEntity> banners;
  final PageController _pageController = PageController();
  BannerSlider({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              physics: defualtScrollPhysics,
              itemBuilder: (context, index) {
                return _sliderItem(banners: banners[index]);
              }),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: banners.length,
                effect: WormEffect(
                    dotHeight: 3,
                    spacing: 4,
                    dotWidth: 18,
                    activeDotColor: Theme.of(context).colorScheme.onBackground,
                    dotColor: Colors.grey.shade300),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _sliderItem extends StatelessWidget {
  const _sliderItem({
    super.key,
    required this.banners,
  });

  final BannerEntity banners;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageurl: banners.imageurl,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
