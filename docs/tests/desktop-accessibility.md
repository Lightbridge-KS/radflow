---
summary: Desktop accessibility naming contract and verified macOS smoke scenarios.
read_when: Adding interactive controls or debugging desktop UI automation and semantics.
---

# Desktop accessibility

## Control naming

Text fields and Material dropdowns have visible decoration labels, but macOS
accessibility clients may report only their editable values. `ControlSemantics`
places each input or output in a named group with explicit child nodes. The group
name stays available when the value is blank or changes; the child retains its
native role, focus, editing actions, and enabled state. Select the field inside
the named group rather than relying on its position in the form.

Keep one logical control per group. Do not merge a whole form or a dropdown's
menu choices into one semantic node. TI-RADS names include the nodule ID so
multiple cards remain distinguishable.

Cupertino checkboxes receive `semanticLabel` directly. Their adjacent visual
text is excluded from semantics to avoid duplicate announcements. Icon actions
have explicit names, and repeated calculator actions identify their subject
(for example, `Generate prostate volume` and `Reset spine height loss`).
Navigation and dialog-close icons supply their own action labels.
The version action has its own semantic boundary so the app title does not
become part of its click target.

## Automated checks

Run with the repository-pinned SDK:

```sh
fvm flutter analyze
fvm flutter test
```

Verified on 2026-10-18: analysis reported no issues and all 29 tests passed,
including five accessibility regression tests. Formatting and whitespace checks
also passed.

`test/accessibility/controls_test.dart` checks:

- Named field groups preserve native text-field roles, editable values, focus
  actions, and reset behavior.
- Cascading selectors preserve selectable menu entries and dependent enabled
  states as selections change.
- Checkbox names belong to actionable nodes with checked and enabled states.
- The menu and version actions expose independent named button nodes and open
  their respective UI through semantic actions.

## Native verification — 2026-10-18

Verified with Flutter 3.38.1, macOS ARM64, debug mode:

```sh
fvm flutter run -d macos
```

All scenarios below passed through the native desktop accessibility interface
using synthetic inputs:

| Area | Observed behavior |
| --- | --- |
| Abdomen | Named input and output groups; distinct Generate/Copy/Reset labels; `4 5 6` generated the displayed `63 ml` snippet; reset cleared fields; `abc` showed validation feedback. |
| Protocol ER | Named Category → Exam → Protocol groups; Body → CTWA → Routine WA selection; ETT/Pregnancy state changes and synthetic eGFR input appeared in generated output; reset cleared them. |
| Protocol CVS | Named exam, protocol, author role, name, telephone, and output groups; image-check toggles exposed state changes; clearing the parent cleared the dependent checkbox; author role selection worked. |
| Liver | Three named T2* inputs accepted synthetic values; generation populated the named report output; reset cleared fields. |
| TI-RADS | Adding a second nodule exposed distinct location/size/selector groups and Reset/Delete names; its location field accepted text; its Delete action removed the test card. |
| Template editor | Named selector retained its identity after changing calculators; template field and reset action were named; named Close action returned to Settings. |
| Home shell | Named menu button opened navigation; the independent Version information button opened its dialog and Close dismissed it. |

Refresh the accessibility tree after actions and reacquire the app binding after
hot reload when native element IDs become stale. Some names deliberately live
on the group containing the native field. This is an interaction smoke check;
it does not validate clinical calculations or constitute a full screen-reader
audit. Other desktop platforms have not been verified.
