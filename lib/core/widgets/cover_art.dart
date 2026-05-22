import 'dart:math';
import 'package:flutter/material.dart';

class CoverArt extends StatelessWidget {
  const CoverArt({
    super.key,
    required this.seed,
    this.width = 116,
    this.height = 164,
    this.radius = 8.0,
  });

  final String seed;
  final double width;
  final double height;
  final double radius;

  static const List<List<Color>> _palettes = [
    [Color(0xFFC0532B), Color(0xFF8B3318), Color(0xFFFAEDE7)],
    [Color(0xFF1A3A5C), Color(0xFF0D2238), Color(0xFFE8F0F8)],
    [Color(0xFF2E7D4E), Color(0xFF1A5C34), Color(0xFFE8F5ED)],
    [Color(0xFFB8723A), Color(0xFF8B5020), Color(0xFFFFF4E8)],
    [Color(0xFF6B4C8A), Color(0xFF4A2E6A), Color(0xFFF4EEF8)],
    [Color(0xFF8A3A4A), Color(0xFF621828), Color(0xFFF8EEEF)],
    [Color(0xFF2A6B8A), Color(0xFF184A62), Color(0xFFEEF5F8)],
    [Color(0xFF5C7A2E), Color(0xFF3A5818), Color(0xFFF0F5E8)],
  ];

  @override
  Widget build(BuildContext context) {
    final hash = seed.hashCode.abs();
    final rng = Random(hash);
    final paletteIdx = rng.nextInt(_palettes.length);
    final palette = _palettes[paletteIdx];
    final motif = rng.nextInt(16);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        size: Size(width, height),
        painter: _MotifPainter(
          primary: palette[0],
          deep: palette[1],
          light: palette[2],
          motif: motif,
          seed: hash,
        ),
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  const _MotifPainter({
    required this.primary,
    required this.deep,
    required this.light,
    required this.motif,
    required this.seed,
  });

  final Color primary;
  final Color deep;
  final Color light;
  final int motif;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = light;
    canvas.drawRect(Offset.zero & size, bg);

    switch (motif % 16) {
      case 0:
        _paintDiagonalStripes(canvas, size);
      case 1:
        _paintCircles(canvas, size);
      case 2:
        _paintWaves(canvas, size);
      case 3:
        _paintDiamond(canvas, size);
      case 4:
        _paintGrid(canvas, size);
      case 5:
        _paintTriangles(canvas, size);
      case 6:
        _paintDots(canvas, size);
      case 7:
        _paintHexagons(canvas, size);
      case 8:
        _paintZigzag(canvas, size);
      case 9:
        _paintCrossHatch(canvas, size);
      case 10:
        _paintArcs(canvas, size);
      case 11:
        _paintLeaves(canvas, size);
      case 12:
        _paintSpiral(canvas, size);
      case 13:
        _paintBands(canvas, size);
      case 14:
        _paintStars(canvas, size);
      case 15:
        _paintCheckers(canvas, size);
    }

    final border = Paint()
      ..color = deep.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, border);
  }

  void _paintDiagonalStripes(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.18)
      ..strokeWidth = 12;
    for (double i = -s.height; i < s.width + s.height; i += 24) {
      canvas.drawLine(Offset(i, 0), Offset(i + s.height, s.height), p);
    }
    final accent = Paint()..color = primary.withValues(alpha: 0.5);
    final r = Rect.fromCenter(
        center: Offset(s.width * 0.5, s.height * 0.45),
        width: s.width * 0.7,
        height: s.height * 0.14);
    canvas.drawRect(r, accent);
  }

  void _paintCircles(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 1; i <= 6; i++) {
      canvas.drawCircle(
          Offset(s.width * 0.5, s.height * 0.45), i * 18.0, p);
    }
    final filled = Paint()..color = primary.withValues(alpha: 0.6);
    canvas.drawCircle(
        Offset(s.width * 0.5, s.height * 0.45), 20, filled);
  }

  void _paintWaves(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (double y = 20; y < s.height; y += 20) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x < s.width; x += 20) {
        path.quadraticBezierTo(x + 10, y - 10, x + 20, y);
      }
      canvas.drawPath(path, p);
    }
  }

  void _paintDiamond(Canvas canvas, Size s) {
    final p = Paint()..color = primary.withValues(alpha: 0.5);
    final path = Path()
      ..moveTo(s.width * 0.5, s.height * 0.15)
      ..lineTo(s.width * 0.85, s.height * 0.45)
      ..lineTo(s.width * 0.5, s.height * 0.75)
      ..lineTo(s.width * 0.15, s.height * 0.45)
      ..close();
    canvas.drawPath(path, p);
    final inner = Paint()
      ..color = deep.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path2 = Path()
      ..moveTo(s.width * 0.5, s.height * 0.25)
      ..lineTo(s.width * 0.75, s.height * 0.45)
      ..lineTo(s.width * 0.5, s.height * 0.65)
      ..lineTo(s.width * 0.25, s.height * 0.45)
      ..close();
    canvas.drawPath(path2, inner);
  }

  void _paintGrid(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (double x = 0; x < s.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, s.height), p);
    }
    for (double y = 0; y < s.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(s.width, y), p);
    }
    final accent = Paint()..color = primary.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(s.width * 0.5, s.height * 0.4), 22, accent);
  }

  void _paintTriangles(Canvas canvas, Size s) {
    final rng = Random(seed);
    final p = Paint()..color = primary.withValues(alpha: 0.35);
    for (int i = 0; i < 8; i++) {
      final cx = rng.nextDouble() * s.width;
      final cy = rng.nextDouble() * s.height;
      final r = 10 + rng.nextDouble() * 20;
      final path = Path()
        ..moveTo(cx, cy - r)
        ..lineTo(cx + r * 0.866, cy + r * 0.5)
        ..lineTo(cx - r * 0.866, cy + r * 0.5)
        ..close();
      canvas.drawPath(path, p);
    }
  }

  void _paintDots(Canvas canvas, Size s) {
    final p = Paint()..color = primary.withValues(alpha: 0.3);
    for (double x = 12; x < s.width; x += 20) {
      for (double y = 12; y < s.height; y += 20) {
        canvas.drawCircle(Offset(x, y), 3, p);
      }
    }
    final accent = Paint()..color = primary.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(s.width * 0.5, s.height * 0.42), 18, accent);
  }

  void _paintHexagons(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    void hex(double cx, double cy, double r) {
      final path = Path();
      for (int i = 0; i < 6; i++) {
        final angle = pi / 180 * (60 * i - 30);
        final x = cx + r * cos(angle);
        final y = cy + r * sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, p);
    }

    for (double row = 0; row < 6; row++) {
      for (double col = 0; col < 4; col++) {
        hex(col * 34 + (row % 2 == 0 ? 0 : 17), row * 30, 18);
      }
    }
  }

  void _paintZigzag(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (double y = 20; y < s.height; y += 30) {
      final path = Path();
      path.moveTo(0, y);
      double x = 0;
      bool up = true;
      while (x < s.width) {
        x += 15;
        path.lineTo(x, up ? y - 12 : y + 12);
        up = !up;
      }
      canvas.drawPath(path, p);
    }
  }

  void _paintCrossHatch(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (double i = -s.height; i < s.width + s.height; i += 15) {
      canvas.drawLine(Offset(i, 0), Offset(i + s.height, s.height), p);
      canvas.drawLine(Offset(i + s.height, 0), Offset(i, s.height), p);
    }
    final block = Paint()..color = primary.withValues(alpha: 0.5);
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset(s.width * 0.5, s.height * 0.42),
          width: s.width * 0.55,
          height: s.height * 0.2),
      block,
    );
  }

  void _paintArcs(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (int i = 1; i <= 5; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(0, s.height), radius: i * 40.0),
        -pi / 2,
        pi / 2,
        false,
        p,
      );
    }
    final filled = Paint()..color = primary.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(s.width * 0.65, s.height * 0.35), 22, filled);
  }

  void _paintLeaves(Canvas canvas, Size s) {
    final p = Paint()..color = primary.withValues(alpha: 0.3);
    void leaf(double cx, double cy, double angle) {
      final path = Path();
      final c = cos(angle);
      final sv = sin(angle);
      path.moveTo(cx, cy);
      path.quadraticBezierTo(
          cx + c * 30 - sv * 15, cy + sv * 30 + c * 15, cx + c * 60, cy + sv * 60);
      path.quadraticBezierTo(
          cx + c * 30 + sv * 15, cy + sv * 30 - c * 15, cx, cy);
      canvas.drawPath(path, p);
    }

    for (int i = 0; i < 6; i++) {
      leaf(s.width * 0.5, s.height * 0.45, i * pi / 3);
    }
  }

  void _paintSpiral(Canvas canvas, Size s) {
    final p = Paint()
      ..color = primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    final cx = s.width * 0.5;
    final cy = s.height * 0.45;
    path.moveTo(cx, cy);
    for (double t = 0; t < pi * 8; t += 0.1) {
      final r = t * 5;
      path.lineTo(cx + r * cos(t), cy + r * sin(t));
    }
    canvas.drawPath(path, p);
  }

  void _paintBands(Canvas canvas, Size s) {
    final colors = [
      primary.withValues(alpha: 0.5),
      primary.withValues(alpha: 0.2),
      primary.withValues(alpha: 0.35),
      primary.withValues(alpha: 0.15),
    ];
    final bandH = s.height / colors.length;
    for (int i = 0; i < colors.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(0, i * bandH, s.width, bandH),
        Paint()..color = colors[i],
      );
    }
  }

  void _paintStars(Canvas canvas, Size s) {
    final rng = Random(seed + 1);
    final p = Paint()..color = primary.withValues(alpha: 0.35);

    void star(double cx, double cy, double outerR, double innerR) {
      final path = Path();
      for (int i = 0; i < 10; i++) {
        final angle = i * pi / 5 - pi / 2;
        final r = i.isEven ? outerR : innerR;
        final x = cx + r * cos(angle);
        final y = cy + r * sin(angle);
        i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(path, p);
    }

    for (int i = 0; i < 6; i++) {
      final size = 8 + rng.nextDouble() * 16;
      star(rng.nextDouble() * s.width, rng.nextDouble() * s.height, size,
          size * 0.45);
    }
  }

  void _paintCheckers(Canvas canvas, Size s) {
    final p = Paint()..color = primary.withValues(alpha: 0.2);
    const size = 18.0;
    for (double x = 0; x < s.width; x += size) {
      for (double y = 0; y < s.height; y += size) {
        final col = (x / size).floor();
        final row = (y / size).floor();
        if ((col + row) % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(x, y, size, size), p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_MotifPainter old) =>
      old.primary != primary ||
      old.motif != motif ||
      old.seed != seed;
}
