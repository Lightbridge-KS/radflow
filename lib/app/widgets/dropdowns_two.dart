import 'package:flutter/material.dart';

/// A clean, focused two-level dependent dropdown component.
///
/// Sibling of [ThreeLevelDropdowns] for cases where only two cascading
/// selections are needed (e.g. Exam → Protocol). Same callback contract,
/// same cascading-reset semantics — changing level 1 clears level 2.
class TwoLevelDropdowns extends StatefulWidget {
  /// Hierarchical choice structure using internal IDs:
  /// `level1Id -> List<level2Id>`.
  final Map<String, List<String>> choiceIdMap;

  /// Mapping from internal IDs to user-visible display names.
  final Map<String, String> idDispMap;

  /// Labels for each dropdown level (optional).
  final String? level1Label;
  final String? level2Label;

  /// Hint texts for each dropdown (optional).
  final String? level1Hint;
  final String? level2Hint;

  /// Selection callback. Emits `{'level1': id, 'level2': id}` with either
  /// value possibly `null` when not yet chosen.
  final Function(Map<String, String?>) onSelectionChanged;

  const TwoLevelDropdowns({
    super.key,
    required this.choiceIdMap,
    required this.idDispMap,
    this.level1Label,
    this.level2Label,
    this.level1Hint,
    this.level2Hint,
    required this.onSelectionChanged,
  });

  @override
  State<TwoLevelDropdowns> createState() => TwoLevelDropdownsState();
}

class TwoLevelDropdownsState extends State<TwoLevelDropdowns> {
  String? _selectedLevel1Id;
  String? _selectedLevel2Id;

  List<String> get _availableLevel2Ids {
    if (_selectedLevel1Id == null) return [];
    return widget.choiceIdMap[_selectedLevel1Id!] ?? [];
  }

  void _onLevel1Changed(String? newLevel1Id) {
    setState(() {
      _selectedLevel1Id = newLevel1Id;
      _selectedLevel2Id = null;
    });
    _notifySelectionChanged();
  }

  void _onLevel2Changed(String? newLevel2Id) {
    setState(() {
      _selectedLevel2Id = newLevel2Id;
    });
    _notifySelectionChanged();
  }

  /// Resets both levels and notifies the parent. Public so screens can drive
  /// reset via a `GlobalKey<TwoLevelDropdownsState>`.
  void reset() {
    setState(() {
      _selectedLevel1Id = null;
      _selectedLevel2Id = null;
    });
    _notifySelectionChanged();
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged({
      'level1': _selectedLevel1Id,
      'level2': _selectedLevel2Id,
    });
  }

  String _getDisplayName(String id) {
    return widget.idDispMap[id] ?? id;
  }

  List<DropdownMenuEntry<String>> _buildMenuEntries(List<String> ids) {
    return ids
        .map((String id) => DropdownMenuEntry<String>(
              value: id,
              label: _getDisplayName(id),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownSection(
          title: widget.level1Label,
          subtitle: widget.level1Label != null
              ? 'Choose your ${widget.level1Label!.toLowerCase()}'
              : null,
          hintText: widget.level1Hint ?? 'Exam',
          value: _selectedLevel1Id,
          items: widget.choiceIdMap.keys.toList(),
          onChanged: _onLevel1Changed,
          isEnabled: true,
        ),
        const SizedBox(height: 20),
        _buildDropdownSection(
          title: widget.level2Label,
          subtitle: null,
          hintText: widget.level2Hint ?? 'Protocol',
          value: _selectedLevel2Id,
          items: _availableLevel2Ids,
          onChanged: _onLevel2Changed,
          isEnabled: _selectedLevel1Id != null,
        ),
      ],
    );
  }

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
          width: MediaQuery.of(context).size.width * 0.5,
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
