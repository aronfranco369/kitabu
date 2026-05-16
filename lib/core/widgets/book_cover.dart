import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models.dart';
import 'cover_art.dart';

class BookCover extends StatelessWidget {
  const BookCover(
    this.book, {
    super.key,
    this.width = 116,
    this.height = 164,
    this.radius = 8.0,
    this.badge = true,
  });

  final Book book;
  final double width;
  final double height;
  final double radius;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    Widget cover;
    if (book.coverUrl != null && book.coverUrl!.isNotEmpty) {
      cover = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: book.coverUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => CoverArt(
            seed: book.id,
            width: width,
            height: height,
            radius: radius,
          ),
          placeholder: (_, __) => CoverArt(
            seed: book.id,
            width: width,
            height: height,
            radius: radius,
          ),
        ),
      );
    } else {
      cover = CoverArt(
        seed: book.id,
        width: width,
        height: height,
        radius: radius,
      );
    }

    if (!badge || book.isFree == false) return cover;

    return Stack(
      children: [
        cover,
        if (book.isFree)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D4E),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'FREE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
