import 'package:flutter/material.dart';
import '../../../services/design/design_cvs/design_cvs_protocol_data.dart';
import '../../widgets/dropdowns_two.dart';

/// Input form for the Protocol CVS screen.
///
/// Currently only hosts the cascading Exam → Protocol dropdowns. Kept as a
/// separate widget (mirroring `DesignERInput`) so additional fields can be
/// dropped in later without restructuring the screen.
class DesignCvsInput extends StatefulWidget {
  /// Emits the selected `protocolId` (or `null` when the protocol level is
  /// not yet chosen).
  final void Function(String? protocolId) onSelectionChanged;

  const DesignCvsInput({
    super.key,
    required this.onSelectionChanged,
  });

  @override
  State<DesignCvsInput> createState() => DesignCvsInputState();
}

class DesignCvsInputState extends State<DesignCvsInput> {
  final GlobalKey<TwoLevelDropdownsState> _dropdownsKey =
      GlobalKey<TwoLevelDropdownsState>();

  /// Resets both dropdowns and re-emits `null` to the parent.
  void reset() {
    _dropdownsKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return TwoLevelDropdowns(
      key: _dropdownsKey,
      choiceIdMap: DesignCvsProtocolData.choiceIdMap,
      idDispMap: DesignCvsProtocolData.idDispMap,
      onSelectionChanged: (selectionMap) {
        widget.onSelectionChanged(selectionMap['level2']);
      },
    );
  }
}
