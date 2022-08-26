import 'package:shell_email_password_login/shell_email_password_login.dart';

class EmailPasswordFormController {
  EmailPasswordFormState? _state;

  void attach(EmailPasswordFormState state) {
    _state = state;
  }

  EmailPasswordFormData? submit() {
    assert(
      _state != null,
      'You cannot save a controller '
      'without using the controller in an email password form',
    );
    return _state?.save();
  }

  void setData(EmailPasswordFormData data) {
    assert(
      _state != null,
      'You cannot set data to a controller '
      'without using the controller in an email password form',
    );
    _state?.setData(data);
  }

  void reset() {
    setData(EmailPasswordFormData());
  }

  void dispose() {
    _state = null;
  }
}
