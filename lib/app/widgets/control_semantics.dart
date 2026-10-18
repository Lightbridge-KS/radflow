import 'package:flutter/widgets.dart';

/// Keeps a control's name visible independently of its editable value.
///
/// macOS accessibility clients may display only the value of text fields and
/// dropdowns. A named group supplies a stable anchor without replacing the
/// child's native editing, selection, focus, or enabled-state semantics.
/// Keep one logical control in each group; never group an entire form here.
class ControlSemantics extends StatelessWidget {
  final String label;
  final Widget child;

  const ControlSemantics({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: label,
      child: child,
    );
  }
}
