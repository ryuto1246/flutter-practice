class ValidationMixin {
  String? validateEmail(value) {
    if (value != null && !value.contains('@')) {
      return 'Please enter a valid email';
    }
  }

  String? validatePassword(value) {
    if (value != null && value.length < 4) {
      return 'Password must be at least 4 characters';
    }
  }
}
