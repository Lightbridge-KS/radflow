/// The role of the person filling out a ward protocol form.
///
/// `label` doubles as the dropdown display text and the output line prefix
/// (e.g. `Fellow: <name> (Tel: <tel>)`), so changes here propagate to both
/// the UI and the rendered protocol.
enum ProtocolAuthor {
  resident('Resident'),
  fellow('Fellow'),
  staff('Staff');

  final String label;
  const ProtocolAuthor(this.label);
}
