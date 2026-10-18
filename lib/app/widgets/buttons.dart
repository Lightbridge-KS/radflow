import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String semanticLabel;

  const GenerateButton({
    super.key,
    required this.onPressed,
    this.semanticLabel = 'Generate',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.create),
      label: Text('Generate', semanticsLabel: semanticLabel),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  final TextEditingController controller;
  final String semanticLabel;

  const CopyButton({
    super.key,
    required this.controller,
    this.semanticLabel = 'Copy to clipboard',
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: controller.text));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: controller.text.isNotEmpty
          ? () => _copyToClipboard(context)
          : null,
      icon: Icon(Icons.copy, semanticLabel: semanticLabel),
      tooltip: 'Copy to clipboard',
    );
  }
}
