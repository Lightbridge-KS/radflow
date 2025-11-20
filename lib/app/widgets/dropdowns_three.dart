import 'package:flutter/material.dart';

// ===== SIMPLIFIED REUSABLE COMPONENT =====
/// A clean, focused three-level dependent dropdown component.
/// 
/// This component ONLY handles dropdown logic and UI.
/// It returns selections as a Map and lets parent widgets handle display logic.
/// 
/// Key benefits:
/// - Single responsibility: only dropdown functionality
/// - Highly reusable: no unwanted UI elements
/// - Easy integration: fits into any form or dialog
/// - Clean API: simple Map-based return value
/// - Flexible UI: labels and hints are optional for simplified interfaces
class ThreeLevelDropdowns extends StatefulWidget {
  /// Hierarchical choice structure using internal IDs
  final Map<String, Map<String, List<String>>> choiceIdMap;
  
  /// Mapping from internal IDs to user-visible display names
  final Map<String, String> idDispMap;
  
  /// Labels for each dropdown level (optional)
  final String? level1Label;
  final String? level2Label;
  final String? level3Label;
  
  /// Hint texts for each dropdown (optional)
  final String? level1Hint;
  final String? level2Hint;
  final String? level3Hint;
  
  /// Callback function that returns selection as Map
  /// Format: {'level1': id, 'level2': id, 'level3': id}
  final Function(Map<String, String?>) onSelectionChanged;

  const ThreeLevelDropdowns({
    super.key,
    required this.choiceIdMap,
    required this.idDispMap,
    this.level1Label,
    this.level2Label,
    this.level3Label,
    this.level1Hint,
    this.level2Hint,
    this.level3Hint,
    required this.onSelectionChanged,
  });

  @override
  State<ThreeLevelDropdowns> createState() => _ThreeLevelDropdownsState();
}

class _ThreeLevelDropdownsState extends State<ThreeLevelDropdowns> {
  // Internal state tracking selected IDs
  String? _selectedLevel1Id;
  String? _selectedLevel2Id;
  String? _selectedLevel3Id;

  // Computed properties for available options
  List<String> get _availableLevel2Ids {
    if (_selectedLevel1Id == null) return [];
    return widget.choiceIdMap[_selectedLevel1Id!]?.keys.toList() ?? [];
  }

  List<String> get _availableLevel3Ids {
    if (_selectedLevel1Id == null || _selectedLevel2Id == null) return [];
    return widget.choiceIdMap[_selectedLevel1Id!]?[_selectedLevel2Id!] ?? [];
  }

  // Event handlers with cascading reset logic
  void _onLevel1Changed(String? newLevel1Id) {
    setState(() {
      _selectedLevel1Id = newLevel1Id;
      _selectedLevel2Id = null;  // Reset dependent selections
      _selectedLevel3Id = null;
    });
    _notifySelectionChanged();
  }

  void _onLevel2Changed(String? newLevel2Id) {
    setState(() {
      _selectedLevel2Id = newLevel2Id;
      _selectedLevel3Id = null;  // Reset dependent selection
    });
    _notifySelectionChanged();
  }

  void _onLevel3Changed(String? newLevel3Id) {
    setState(() {
      _selectedLevel3Id = newLevel3Id;
    });
    _notifySelectionChanged();
  }

  /// Notifies parent widget with current selection as Map
  void _notifySelectionChanged() {
    widget.onSelectionChanged({
      'level1': _selectedLevel1Id,
      'level2': _selectedLevel2Id,
      'level3': _selectedLevel3Id,
    });
  }

  /// Helper method to get display name from ID
  String _getDisplayName(String id) {
    return widget.idDispMap[id] ?? id;
  }

  /// Builds dropdown menu entries from a list of IDs
  List<DropdownMenuEntry<String>> _buildMenuEntries(List<String> ids) {
    return ids.map((String id) => DropdownMenuEntry<String>(
      value: id,
      label: _getDisplayName(id),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level 1 Dropdown
        _buildDropdownSection(
          title: widget.level1Label,
          subtitle: widget.level1Label != null ? 'Choose your ${widget.level1Label!.toLowerCase()}' : null,
          hintText: widget.level1Hint ?? 'Category',
          value: _selectedLevel1Id,
          items: widget.choiceIdMap.keys.toList(),
          onChanged: _onLevel1Changed,
          isEnabled: true,
        ),

        const SizedBox(height: 20),

        // Level 2 Dropdown
        _buildDropdownSection(
          title: widget.level2Label,
          subtitle: null,
          hintText: widget.level2Hint ?? 'Exam',
          value: _selectedLevel2Id,
          items: _availableLevel2Ids,
          onChanged: _onLevel2Changed,
          isEnabled: _selectedLevel1Id != null,
        ),

        const SizedBox(height: 20),

        // Level 3 Dropdown
        _buildDropdownSection(
          title: widget.level3Label,
          subtitle: null,
          hintText: widget.level3Hint ?? 'Protocol',
          value: _selectedLevel3Id,
          items: _availableLevel3Ids,
          onChanged: _onLevel3Changed,
          isEnabled: _selectedLevel2Id != null,
        ),
      ],
    );
  }

  /// Builds a consistent dropdown section
  Widget _buildDropdownSection({
    required String? title,
    required String? subtitle,
    required String hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isEnabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownMenu<String>(
          width: MediaQuery.of(context).size.width * 0.5, // Adjust this factor as needed
          hintText: hintText,
          onSelected: isEnabled ? onChanged : null,
          enabled: isEnabled,
          label: Text(hintText), 
          dropdownMenuEntries: _buildMenuEntries(items),
        ),
      ],
    );
  }
}