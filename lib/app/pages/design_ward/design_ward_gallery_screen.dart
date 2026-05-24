import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router.dart';

/// Gallery screen listing body-part-specific ward protocols.
///
/// Only Protocol CVS is wired today; Chest / Abdomen / MSK render as disabled
/// stubs (no `route`) following the same convention as the home-screen
/// feature grid.
class DesignWardGalleryScreen extends StatelessWidget {
  const DesignWardGalleryScreen({super.key});

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
                child: _ProtocolCardsGrid(),
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
                    Icons.local_hospital_outlined,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Protocol Ward',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Body-part-specific CT and MR protocols for ward studies',
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

class _ProtocolCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? route;

  const _ProtocolCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}

class _ProtocolCardsGrid extends StatelessWidget {
  const _ProtocolCardsGrid();

  @override
  Widget build(BuildContext context) {
    const protocols = [
      _ProtocolCardData(
        title: 'Protocol CVS',
        subtitle: 'Cardiovascular CTA and MRA protocols',
        icon: Icons.favorite_outline,
        route: Routes.designCvs,
      ),
      _ProtocolCardData(
        title: 'Protocol Chest',
        subtitle: 'Thoracic CT and MR protocols',
        icon: Icons.air_outlined,
        route: null,
      ),
      _ProtocolCardData(
        title: 'Protocol Abdomen',
        subtitle: 'Abdominopelvic CT and MR protocols',
        icon: Icons.accessibility_new_outlined,
        route: null,
      ),
      _ProtocolCardData(
        title: 'Protocol MSK',
        subtitle: 'Musculoskeletal CT and MR protocols',
        icon: Icons.fitness_center_outlined,
        route: null,
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
      itemCount: protocols.length,
      itemBuilder: (context, index) {
        return _ProtocolCard(protocol: protocols[index]);
      },
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final _ProtocolCardData protocol;

  const _ProtocolCard({required this.protocol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isEnabled = protocol.route != null;

    return Card(
      elevation: 2,
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: isEnabled ? () => context.go(protocol.route!) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                protocol.icon,
                size: 32,
                color: isEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      protocol.title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isEnabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  if (!isEnabled)
                    Text(
                      'Soon',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                protocol.subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant
                      .withValues(alpha: isEnabled ? 1.0 : 0.6),
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
