import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../services/design/design_ward_common/ward_common.dart';

/// Reusable input block for Protocol Ward screens: a "Check ภาพ" checkbox
/// gating two phase sub-checkboxes (ก่อน / หลัง IV contrast), plus the
/// Resident Name and Tel fields.
///
/// State stays internal and is emitted as a fresh [WardCommonValues] on
/// every change. Toggling `Check ภาพ` off clears and disables the two
/// sub-checkboxes so the rendered output cannot reach an ambiguous state.
class WardCommonInput extends StatefulWidget {
  final void Function(WardCommonValues values) onChanged;

  /// Fires when the user presses Enter inside Name or Tel. Screens wire this
  /// to their Generate action so a keyboard-driven flow doesn't require a
  /// mouse click after typing.
  final VoidCallback? onSubmit;

  const WardCommonInput({
    super.key,
    required this.onChanged,
    this.onSubmit,
  });

  @override
  State<WardCommonInput> createState() => WardCommonInputState();
}

class WardCommonInputState extends State<WardCommonInput> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  bool _checkImage = false;
  bool _beforeIv = false;
  bool _afterIv = false;
  ProtocolAuthor _author = ProtocolAuthor.resident;

  @override
  void dispose() {
    _nameController.dispose();
    _telController.dispose();
    super.dispose();
  }

  /// Clears every field and re-emits the empty value.
  void reset() {
    setState(() {
      _checkImage = false;
      _beforeIv = false;
      _afterIv = false;
      _author = ProtocolAuthor.resident;
      _nameController.clear();
      _telController.clear();
    });
    _emit();
  }

  void _emit() {
    widget.onChanged(WardCommonValues(
      checkImage: _checkImage,
      beforeIv: _beforeIv,
      afterIv: _afterIv,
      author: _author,
      authorName: _nameController.text,
      authorTel: _telController.text,
    ));
  }

  void _onCheckImageChanged(bool? value) {
    setState(() {
      _checkImage = value ?? false;
      if (!_checkImage) {
        // Sub-checkboxes don't carry meaning without the parent.
        _beforeIv = false;
        _afterIv = false;
      }
    });
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxRow(),
        const SizedBox(height: 16),
        _buildTextFieldsRow(),
      ],
    );
  }

  Widget _buildCheckboxRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _CheckboxTile(
            label: 'Check ภาพ',
            value: _checkImage,
            onChanged: _onCheckImageChanged,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckboxTile(
                label: 'ก่อน IV contrast',
                value: _beforeIv,
                enabled: _checkImage,
                onChanged: (v) {
                  setState(() => _beforeIv = v ?? false);
                  _emit();
                },
              ),
              const SizedBox(height: 8),
              _CheckboxTile(
                label: 'หลัง IV contrast',
                value: _afterIv,
                enabled: _checkImage,
                onChanged: (v) {
                  setState(() => _afterIv = v ?? false);
                  _emit();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: DropdownMenu<ProtocolAuthor>(
            initialSelection: _author,
            expandedInsets: EdgeInsets.zero,
            label: const Text('Role'),
            onSelected: (value) {
              if (value == null) return;
              setState(() => _author = value);
              _emit();
            },
            dropdownMenuEntries: ProtocolAuthor.values
                .map((role) => DropdownMenuEntry<ProtocolAuthor>(
                      value: role,
                      label: role.label,
                    ))
                .toList(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _emit(),
            onSubmitted: (_) => widget.onSubmit?.call(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextField(
            controller: _telController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Tel.',
              hintText: 'Tel.',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _emit(),
            onSubmitted: (_) => widget.onSubmit?.call(),
          ),
        ),
      ],
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool?> onChanged;

  const _CheckboxTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    return Row(
      children: [
        CupertinoCheckbox(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: enabled ? null : TextStyle(color: disabledColor),
        ),
      ],
    );
  }
}
