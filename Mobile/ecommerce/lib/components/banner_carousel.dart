import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({Key? key}) : super(key: key);

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final List<String> items = [
    'assets/images/banner/7.png',
    'assets/images/banner/2.png',
    'assets/images/banner/4.png',
    'assets/images/banner/5.png',
    'assets/images/banner/6.png',
    'assets/images/banner/3.png',
  ];
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel slider
        CarouselSlider(
          items: items.map((item) {
            // Wrap each image in a ClipRRect to apply border radius
            return ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.0), // Specify the border radius
              child: Image.asset(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: 150.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        // Dots (indicators) at the bottom of the carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: _current == entry.key
                //       ? Colors.blue // Active dot color
                //       : Colors.grey, // Inactive dot color
                // ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color.fromARGB(255, 255, 149, 0))
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
