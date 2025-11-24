import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../services/design/designer/designer_protocol_data.dart';
import '../../../services/design/_utils.dart';
import '../../widgets/dropdowns_three.dart';

/// Input form widget containing all fields for protocol generation
class DesignERInput extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelectionChanged;

  const DesignERInput({
    super.key,
    required this.onSelectionChanged,
  });

  @override
  State<DesignERInput> createState() => DesignERInputState();
}

class DesignERInputState extends State<DesignERInput> {
  // Controllers for text fields
  final TextEditingController _npoTimeController = TextEditingController();
  final TextEditingController _egfrDateController = TextEditingController();
  final TextEditingController _egfrValueController = TextEditingController();
  final TextEditingController _renalPremedController = TextEditingController();
  final TextEditingController _allergyPremedController = TextEditingController();
  final TextEditingController _precautionController = TextEditingController();
  final TextEditingController _specialInstController = TextEditingController();
  final TextEditingController _refPhysicianNameController = TextEditingController();
  final TextEditingController _refPhysicianTelController = TextEditingController();

  // Checkbox states
  bool _pregnancy = false;
  bool _hasETT = false;
  bool _hasC1 = false;

  // Protocol selection from dropdowns
  Map<String, String?> _protocolSelection = {
    'level1': null,
    'level2': null,
    'level3': null,
  };

  @override
  void initState() {
    super.initState();
    // Set default eGFR date to current date
    _egfrDateController.text = getCurrentDate();
  }

  @override
  void dispose() {
    _npoTimeController.dispose();
    _egfrDateController.dispose();
    _egfrValueController.dispose();
    _renalPremedController.dispose();
    _allergyPremedController.dispose();
    _precautionController.dispose();
    _specialInstController.dispose();
    _refPhysicianNameController.dispose();
    _refPhysicianTelController.dispose();
    super.dispose();
  }

  /// Get all input values as a map
  Map<String, dynamic> get() {
    return {
      'protocolId': _protocolSelection['level3'],
      'npoTime': _npoTimeController.text,
      'egfrDate': _egfrDateController.text,
      'egfrValue': _egfrValueController.text,
      'renalPremed': _renalPremedController.text,
      'allergyPremed': _allergyPremedController.text,
      'pregnancy': _pregnancy,
      'hasETT': _hasETT,
      'hasC1': _hasC1,
      'hasPrecaution': _precautionController.text,
      'specialInst': _specialInstController.text,
      'refPhysicianName': _refPhysicianNameController.text,
      'refPhysicianTel': _refPhysicianTelController.text,
    };
  }

  /// Reset all inputs to default values
  void reset() {
    setState(() {
      _npoTimeController.clear();
      _egfrDateController.text = getCurrentDate();
      _egfrValueController.clear();
      _renalPremedController.clear();
      _allergyPremedController.clear();
      _precautionController.clear();
      _specialInstController.clear();
      _refPhysicianNameController.clear();
      _refPhysicianTelController.clear();
      _pregnancy = false;
      _hasETT = false;
      _hasC1 = false;
      _protocolSelection = {
        'level1': null,
        'level2': null,
        'level3': null,
      };
    });
    _notifySelectionChanged();
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged(get());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Three-level dropdowns
        ThreeLevelDropdowns(
          choiceIdMap: DesignErProtocolData.choiceIdMap,
          idDispMap: DesignErProtocolData.idDispMap,
          onSelectionChanged: (selectionMap) {
            setState(() {
              _protocolSelection = selectionMap;
            });
            _notifySelectionChanged();
          },
        ),

        const SizedBox(height: 16),

        // Checkboxes row
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CupertinoCheckbox(
                    value: _hasETT,
                    onChanged: (value) {
                      setState(() {
                        _hasETT = value ?? false;
                      });
                      _notifySelectionChanged();
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('ETT'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CupertinoCheckbox(
                    value: _hasC1,
                    onChanged: (value) {
                      setState(() {
                        _hasC1 = value ?? false;
                      });
                      _notifySelectionChanged();
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('C1'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  CupertinoCheckbox(
                    value: _pregnancy,
                    onChanged: (value) {
                      setState(() {
                        _pregnancy = value ?? false;
                      });
                      _notifySelectionChanged();
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text('Pregnancy'),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // eGFR row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _egfrValueController,
                decoration: const InputDecoration(
                  labelText: 'eGFR',
                  hintText: 'eGFR Value',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _egfrDateController,
                decoration: const InputDecoration(
                  labelText: 'eGFR Date',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Premedication row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _renalPremedController,
                decoration: const InputDecoration(
                  labelText: 'Renal Premed',
                  hintText: 'Renal Premed',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _allergyPremedController,
                decoration: const InputDecoration(
                  labelText: 'Allergy Premed',
                  hintText: 'Allergy Premed',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // NPO time
        TextField(
          controller: _npoTimeController,
          decoration: const InputDecoration(
            labelText: 'NPO time',
            hintText: 'NPO time',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _notifySelectionChanged(),
        ),

        const SizedBox(height: 8),

        // Precaution and Special Instruction row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _precautionController,
                decoration: const InputDecoration(
                  labelText: 'Precaution',
                  hintText: 'Precaution',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _specialInstController,
                decoration: const InputDecoration(
                  labelText: 'Special Instruction',
                  hintText: 'Special Instr.',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _notifySelectionChanged(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Ref physician name
        TextField(
          controller: _refPhysicianNameController,
          decoration: const InputDecoration(
            labelText: 'Ref physician name',
            hintText: 'Name of Ref physician',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _notifySelectionChanged(),
        ),

        const SizedBox(height: 8),

        // Ref physician tel
        TextField(
          controller: _refPhysicianTelController,
          decoration: const InputDecoration(
            labelText: 'Ref physician tel',
            hintText: 'PCT of Ref physician',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _notifySelectionChanged(),
        ),
      ],
    );
  }
}
