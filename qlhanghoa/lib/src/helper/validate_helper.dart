class ValidateHelper {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(
      r'^(0[3|5|7|8|9])+([0-9]{8})$',
    );
    return phoneRegex.hasMatch(phoneNumber);
  }
}
