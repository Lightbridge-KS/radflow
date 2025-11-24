import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router.dart';
import '../enums/screen_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Section
          _HeroSection(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),

          // Feature Cards Grid
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _FeatureCardsGrid(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _HeroSection({
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative shapes
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decorative dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DecorativeDot(colorScheme: colorScheme, scalloped: true),
                    const SizedBox(width: 12),
                    _DecorativeDot(colorScheme: colorScheme, scalloped: false),
                    const SizedBox(width: 12),
                    _DecorativeDot(colorScheme: colorScheme, scalloped: true, angle: 45),
                  ],
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'RadFlow',
                  style: textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Streamline Workflow in Radiology',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeDot extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool scalloped;
  final double angle;

  const _DecorativeDot({
    required this.colorScheme,
    this.scalloped = false,
    this.angle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          shape: scalloped ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: scalloped ? BorderRadius.circular(12) : null,
        ),
        child: scalloped
            ? CustomPaint(
                painter: _ScallopedPainter(color: colorScheme.primary),
              )
            : null,
      ),
    );
  }
}

class _ScallopedPainter extends CustomPainter {
  final Color color;

  _ScallopedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    const scallops = 8;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (var i = 0; i < scallops; i++) {
      final angle = (i * 360 / scallops) * math.pi / 180;
      final x = center.dx + radius * 0.7 * (i % 2 == 0 ? 1 : 0.8) * math.cos(angle);
      final y = center.dy + radius * 0.7 * (i % 2 == 0 ? 1 : 0.8) * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeatureCardsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureCardData(
        title: ScreenInfo.designER.title,
        subtitle: 'Generate CT/MRI protocols for Emergency Radiology studies',
        icon: Icons.medical_information_outlined,
        route: Routes.designER,
      ),
      _FeatureCardData(
        title: 'Calculators',
        subtitle: 'Medical calculators and clinical scoring systems',
        icon: Icons.calculate_outlined,
        route: Routes.calculatorAbdomen,
      ),
      _FeatureCardData(
        title: 'Protocols',
        subtitle: 'Imaging protocols and departmental guidelines',
        icon: Icons.description_outlined,
        route: null, // Stub - not implemented yet
      ),
      // _FeatureCardData(
      //   title: 'Reports',
      //   subtitle: 'Structured reporting templates and tools',
      //   icon: Icons.edit_document,
      //   route: null, // Stub - not implemented yet
      // ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(feature: features[index]);
      },
    );
  }
}

class _FeatureCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? route;

  _FeatureCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.route,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureCardData feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isEnabled = feature.route != null;

    return Card(
      elevation: isEnabled ? 2 : 0,
      color: isEnabled
          ? colorScheme.surfaceContainerLow
          : colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: isEnabled
            ? () => context.go(feature.route!)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature.icon,
                size: 32,
                color: isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text(
                feature.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                feature.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 8),
                Text(
                  'Coming soon',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}