import 'package:flutter/material.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/banner/1.png'),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
