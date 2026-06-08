import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PlayerLoadingView extends StatelessWidget {
  final String? posterUrl;
  const PlayerLoadingView({super.key, this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (posterUrl != null)
          Opacity(
            opacity: 0.5,
            child: CachedNetworkImage(
              imageUrl: posterUrl!,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: SinemaxColors.bg2),
              errorBuilder: (_, _, _) => Container(color: SinemaxColors.bg2),
            ),
          )
        else
          Container(color: SinemaxColors.bg2),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x33000000), Color(0x99000000)],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: SinemaxColors.blue,
                strokeWidth: 2.5,
              ),
              const SizedBox(height: 10),
              Text(
                'Loading',
                style: SinemaxTextStyles.body(13, color: SinemaxColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
