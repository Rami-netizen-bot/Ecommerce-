import 'package:flutter/material.dart';

class BannerModel {
  final String title;
  final String buttonText;
  final String? imageUrl;
  final String? assetImagePath;
  final Color backgroundColor;

  BannerModel({
    required this.title,
    required this.buttonText,
    this.imageUrl,
    this.assetImagePath,
    this.backgroundColor = const Color(0xFFE8F1FC),
  });
}