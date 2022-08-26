class EmailPasswordFormData {
  EmailPasswordFormData({
    String? email,
    String? password,
  }) {
    this.email = email ?? '';
    this.password = password ?? '';
  }

  late final String email;
  late final String password;
}
