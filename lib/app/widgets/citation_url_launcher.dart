import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A clickable citation link that opens a URL in the browser
///
/// Supports both web and native platforms with platform-specific URL launching.
/// Shows an error SnackBar with "Copy URL" fallback if launching fails.
class CitationUrlLauncher extends StatelessWidget {
  final String text;
  final String href;

  const CitationUrlLauncher({
    super.key,
    required this.text,
    required this.href,
  });

  Future<void> _launchUrl(BuildContext context) async {
    try {
      // Use url_launcher for native platforms
      final Uri url = Uri.parse(href);
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );

      if (!launched) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open reference: $href'),
              action: SnackBarAction(
                label: 'Copy URL',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: href));
                },
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            action: SnackBarAction(
              label: 'Copy URL',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: href));
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(context),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.open_in_new,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
