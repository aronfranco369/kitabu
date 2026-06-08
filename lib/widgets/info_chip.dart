import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InfoChip extends StatelessWidget {
  final String label;
  const InfoChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SinemaxColors.panel2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SinemaxColors.line, width: 0.5),
      ),
      child: Text(label,
          style: SinemaxTextStyles.body(12, color: SinemaxColors.muted)),
    );
  }
}
