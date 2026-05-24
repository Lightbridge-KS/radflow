import 'package:flutter/material.dart';
import '../../../services/design/design_cvs/design_cvs_protocol_data.dart';
import '../../../services/design/design_ward_common/ward_common.dart';
import '../../widgets/dropdowns_two.dart';
import '_ward_common_input.dart';

/// Aggregate input form for the Protocol CVS screen.
///
/// Composes the protocol selector (cascading Exam → Protocol dropdowns)
/// with the ward-common block (Check ภาพ + Resident). The screen receives
/// a single combined snapshot via [onSelectionChanged].
class DesignCvsInput extends StatefulWidget {
  final void Function(DesignCvsInputValues values) onSelectionChanged;

  /// Fires when the user submits a text field via Enter. The screen wires
  /// this to its Generate action.
  final VoidCallback? onSubmit;

  const DesignCvsInput({
    super.key,
    required this.onSelectionChanged,
    this.onSubmit,
  });

  @override
  State<DesignCvsInput> createState() => DesignCvsInputState();
}

class DesignCvsInputState extends State<DesignCvsInput> {
  final GlobalKey<TwoLevelDropdownsState> _dropdownsKey =
      GlobalKey<TwoLevelDropdownsState>();
  final GlobalKey<WardCommonInputState> _wardCommonKey =
      GlobalKey<WardCommonInputState>();

  String? _protocolId;
  WardCommonValues _wardCommon = const WardCommonValues.empty();

  /// Resets both child widgets back to their initial state.
  void reset() {
    _dropdownsKey.currentState?.reset();
    _wardCommonKey.currentState?.reset();
  }

  void _emit() {
    widget.onSelectionChanged(DesignCvsInputValues(
      protocolId: _protocolId,
      wardCommon: _wardCommon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwoLevelDropdowns(
          key: _dropdownsKey,
          choiceIdMap: DesignCvsProtocolData.choiceIdMap,
          idDispMap: DesignCvsProtocolData.idDispMap,
          onSelectionChanged: (selectionMap) {
            _protocolId = selectionMap['level2'];
            _emit();
          },
        ),
        const SizedBox(height: 16),
        WardCommonInput(
          key: _wardCommonKey,
          onChanged: (values) {
            _wardCommon = values;
            _emit();
          },
          onSubmit: widget.onSubmit,
        ),
      ],
    );
  }
}

/// Combined snapshot emitted to the parent screen.
class DesignCvsInputValues {
  final String? protocolId;
  final WardCommonValues wardCommon;

  const DesignCvsInputValues({
    required this.protocolId,
    required this.wardCommon,
  });
}
