enum EmailPasswordFormValidationError {
  emailNotValid(
    text:
        'The entered value is not a valid email. Use this template something@somedomain.com',
  ),
  emailEmpty(
    text: 'You need to enter an email to log in',
  ),
  passwordEmpty(
    text: 'You need to enter a password to log in',
  );

  const EmailPasswordFormValidationError({
    required this.text,
  });
  final String text;
}
