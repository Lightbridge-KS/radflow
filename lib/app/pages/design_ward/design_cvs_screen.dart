import 'package:flutter/material.dart';
import '../../../services/design/design_cvs/design_cvs.dart';
import '../../widgets/buttons.dart';
import '_design_cvs_input.dart';

/// Protocol CVS screen — generates cardiovascular CT/MR study protocols.
///
/// Mirrors `DesignERScreen` but simpler: only a 2-level Exam → Protocol
/// selector drives generation; no patient-side input fields yet.
class DesignCvsScreen extends StatefulWidget {
  const DesignCvsScreen({super.key});

  @override
  State<DesignCvsScreen> createState() => _DesignCvsScreenState();
}

class _DesignCvsScreenState extends State<DesignCvsScreen> {
  final GlobalKey<DesignCvsInputState> _inputKey =
      GlobalKey<DesignCvsInputState>();
  final TextEditingController _outputController = TextEditingController();

  String? _protocolId;

  bool get _isSelectionComplete => _protocolId != null;

  @override
  void dispose() {
    _outputController.dispose();
    super.dispose();
  }

  Future<void> _generateProtocol() async {
    if (!_isSelectionComplete) {
      _showSnackBar('Please select a protocol first');
      return;
    }

    try {
      final cvs = DesignCvs(protocolId: _protocolId!);
      final template = await cvs.generate();
      setState(() {
        _outputController.text = template;
      });
    } catch (e) {
      _showSnackBar('Error generating protocol: $e');
    }
  }

  void _resetInputs() {
    _inputKey.currentState?.reset();
    setState(() {
      _outputController.clear();
      _protocolId = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildDesktopLayout();
        }
        return _buildMobileLayout();
      },
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: _buildInputCard()),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: _buildOutputSection()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputCard(),
          const SizedBox(height: 16),
          _buildOutputSection(),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DesignCvsInput(
          key: _inputKey,
          onSelectionChanged: (protocolId) {
            setState(() {
              _protocolId = protocolId;
            });
          },
        ),
      ),
    );
  }

  Widget _buildOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _outputController,
              maxLines: 23,
              readOnly: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                hintText: 'Generated protocol will appear here...',
              ),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GenerateButton(
                  onPressed: _isSelectionComplete ? _generateProtocol : null,
                ),
                const SizedBox(width: 8),
                CopyButton(controller: _outputController),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _resetInputs,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
