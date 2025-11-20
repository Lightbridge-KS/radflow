import 'package:flutter/material.dart';
import '../../../services/design/designer/designer.dart';
import '_designer_input.dart';
import '../../widgets/buttons.dart';

class DesignERScreen extends StatefulWidget {
  const DesignERScreen({super.key});

  @override
  State<DesignERScreen> createState() => _DesignERScreenState();
}

class _DesignERScreenState extends State<DesignERScreen> {
  final GlobalKey<DesignERInputState> _inputDesignKey = GlobalKey<DesignERInputState>();
  final TextEditingController _outputController = TextEditingController();

  // State to hold current input values
  Map<String, dynamic> _currentInputs = {};

  // Check if all required selections are complete
  bool get _isSelectionComplete {
    return _currentInputs['protocolId'] != null;
  }

  @override
  void dispose() {
    _outputController.dispose();
    super.dispose();
  }

  /// Generate protocol template
  Future<void> _generateProtocol() async {
    if (!_isSelectionComplete) {
      _showSnackBar('Please select a protocol first');
      return;
    }

    try {
      final designer = Designer(
        protocolId: _currentInputs['protocolId'],
        npoTime: _currentInputs['npoTime'],
        egfrDate: _currentInputs['egfrDate'],
        egfrValue: _currentInputs['egfrValue'],
        renalPremed: _currentInputs['renalPremed'],
        allergyPremed: _currentInputs['allergyPremed'],
        pregnancy: _currentInputs['pregnancy'],
        hasETT: _currentInputs['hasETT'],
        hasC1: _currentInputs['hasC1'],
        hasPrecaution: _currentInputs['hasPrecaution'],
        specialInst: _currentInputs['specialInst'],
        refPhysicianName: _currentInputs['refPhysicianName'],
        refPhysicianTel: _currentInputs['refPhysicianTel'],
      );

      final template = await designer.generate();

      setState(() {
        _outputController.text = template;
      });
    } catch (e) {
      _showSnackBar('Error generating protocol: $e');
    }
  }

  /// Reset all inputs
  void _resetInputs() {
    _inputDesignKey.currentState?.reset();
    setState(() {
      _outputController.clear();
      _currentInputs = {};
    });
  }

  /// Show snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use responsive layout
        if (constraints.maxWidth > 800) {
          // Desktop layout - side by side
          return _buildDesktopLayout();
        } else {
          // Mobile layout - stacked
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Input form
          Expanded(
            flex: 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DesignERInput(
                  key: _inputDesignKey,
                  onSelectionChanged: (inputs) {
                    setState(() {
                      _currentInputs = inputs;
                    });
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Right side - Output and buttons
          Expanded(
            flex: 1,
            child: _buildOutputSection(),
          ),
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
          // Input form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DesignERInput(
                key: _inputDesignKey,
                onSelectionChanged: (inputs) {
                  setState(() {
                    _currentInputs = inputs;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Output and buttons
          _buildOutputSection(),
        ],
      ),
    );
  }

  Widget _buildOutputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Output text field
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _outputController,
                  maxLines: 23,
                  readOnly: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Colors.deepPurple
                    ),
                    hintText: 'Generated protocol will appear here...',
                  ),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Generate and Copy buttons
            Row(
              children: [
                GenerateButton(
                  onPressed: _isSelectionComplete ? _generateProtocol : null,
                ),
                const SizedBox(width: 8),
                CopyButton(
                  controller: _outputController,
                ),
              ],
            ),

            // Reset button
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
