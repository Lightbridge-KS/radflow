import '../config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VersionWidget extends ConsumerWidget {
  const VersionWidget({super.key});
  final String version = AppConfig.appVersion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer(
      builder: (context, ref, child) {

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              version,
              style: TextStyle(
                color: colorScheme.surfaceTint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _showVersionDialog(context, ref),
              child: Tooltip(
                message: "Version Info...",
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.info_outline,
                    color: colorScheme.surfaceTint,
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show version information dialog
  void _showVersionDialog(BuildContext context, WidgetRef ref) {
    final String version = AppConfig.appVersion;
    final String shaHash = AppConfig.shaHash;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('RadFlow'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: $version ($shaHash)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}