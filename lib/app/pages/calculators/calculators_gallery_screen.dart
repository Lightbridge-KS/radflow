import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router.dart';

/// Gallery screen displaying all available calculator screens as feature cards.
class CalculatorsGalleryScreen extends StatelessWidget {
  const CalculatorsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _GalleryHeader(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: _CalculatorCardsGrid(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.3),
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Calculators',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Medical calculators and clinical scoring systems for radiology',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculatorCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _CalculatorCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

class _CalculatorCardsGrid extends StatelessWidget {
  const _CalculatorCardsGrid();

  @override
  Widget build(BuildContext context) {
    const calculators = [
      _CalculatorCardData(
        title: 'Abdomen Calculator',
        subtitle: 'Prostate volume, spine height loss, adrenal CT washout',
        icon: Icons.accessibility_new_outlined,
        route: Routes.calculatorAbdomen,
      ),
      _CalculatorCardData(
        title: 'Liver Calculator',
        subtitle: 'Liver iron concentration (LIC) from MRI T2*',
        icon: Icons.science_outlined,
        route: Routes.calculatorLiver,
      ),
      _CalculatorCardData(
        title: 'TI-RADS Calculator',
        subtitle: 'ACR TI-RADS thyroid nodule assessment',
        icon: Icons.radar,
        route: Routes.calculatorTirads,
      ),
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
      itemCount: calculators.length,
      itemBuilder: (context, index) {
        return _CalculatorCard(calculator: calculators[index]);
      },
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final _CalculatorCardData calculator;

  const _CalculatorCard({required this.calculator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => context.go(calculator.route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                calculator.icon,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                calculator.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                calculator.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
