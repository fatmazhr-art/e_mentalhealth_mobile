class PasswordRules {
  final bool minLength;
  final bool complexity;
  final bool differentFromOld;

  const PasswordRules({
    required this.minLength,
    required this.complexity,
    required this.differentFromOld,
  });

  factory PasswordRules.check(String newPass, String oldPass) {
    return PasswordRules(
      minLength: newPass.length >= 8,
      complexity: RegExp(r'[A-Z]').hasMatch(newPass) &&
          RegExp(r'[0-9]').hasMatch(newPass) &&
          RegExp(r'[^A-Za-z0-9]').hasMatch(newPass),
      differentFromOld: newPass.isNotEmpty && newPass != oldPass,
    );
  }

  int get score =>
      [minLength, complexity, differentFromOld].where((e) => e).length;
  bool get allPassed => score == 3;
}