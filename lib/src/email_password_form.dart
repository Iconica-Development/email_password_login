import 'package:flutter/material.dart';
import 'package:shell_email_password_login/shell_email_password_login.dart';
import 'package:shell_email_password_login/src/email_password_form_data.dart';

class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({
    Key? key,
    this.padding,
    this.emailLabel,
    this.emailPrefixIcon,
    this.passwordLabel,
    this.passwordPrefixIcon,
    this.inputDecoration,
    this.togglePassword = false,
    this.showPasswordDefault = false,
    this.inputTextStyle,
    this.inputContainerBuilder = _defaultInputContainerBuilder,
    this.getValidationError,
  }) : super(key: key);

  final String Function(EmailPasswordFormValidationError error)?
      getValidationError;
  final EdgeInsets? padding;
  final Widget? emailPrefixIcon;
  final Widget? emailLabel;
  final Widget? passwordPrefixIcon;
  final Widget? passwordLabel;
  final bool togglePassword;
  final bool showPasswordDefault;
  final TextStyle? inputTextStyle;
  final InputDecoration? inputDecoration;
  final Widget Function(BuildContext context, Widget input)
      inputContainerBuilder;

  static Widget _defaultInputContainerBuilder(BuildContext _, Widget input) =>
      input;

  @override
  State<EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  late bool _showPasswordText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late EmailPasswordFormData data;

  @override
  void initState() {
    super.initState();
    _showPasswordText = widget.showPasswordDefault;
  }

  String _getErrorText(EmailPasswordFormValidationError error) {
    return widget.getValidationError?.call(error) ?? error.text;
  }

  @override
  Widget build(BuildContext context) {
    // var style = widget.inputTextStyle ?? Theme.of(context).
    return Form(
      key: _formKey,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16.0),
        child: Column(
          children: [
            widget.inputContainerBuilder(
              context,
              TextFormField(
                style: widget.inputTextStyle,
                textInputAction: TextInputAction.next,
                decoration: (widget.inputDecoration ?? const InputDecoration())
                    .copyWith(
                  label: widget.emailLabel,
                  prefixIcon: widget.emailPrefixIcon,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _getErrorText(
                      EmailPasswordFormValidationError.emailEmpty,
                    );
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
                    r"@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return _getErrorText(
                      EmailPasswordFormValidationError.emailNotValid,
                    );
                  }
                  return null;
                },
              ),
            ),
            widget.inputContainerBuilder(
              context,
              TextFormField(
                style: widget.inputTextStyle,
                obscureText: !_showPasswordText,
                textInputAction: TextInputAction.done,
                decoration: (widget.inputDecoration ?? const InputDecoration())
                    .copyWith(
                  label: widget.passwordLabel,
                  prefixIcon: widget.passwordPrefixIcon,
                  suffixIcon: _buildShowPasswordIcon(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _getErrorText(
                      EmailPasswordFormValidationError.passwordEmpty,
                    );
                  }
                  return null;
                },
                onEditingComplete: () {
                  save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void save() {
    var form = _formKey.currentState;
    if (form != null && form.validate()) {
      data = EmailPasswordFormData();
      form.save();
    }
  }

  IconButton? _buildShowPasswordIcon() {
    if (widget.togglePassword) {
      return IconButton(
        onPressed: () {
          setState(() {
            _showPasswordText = !_showPasswordText;
          });
        },
        icon: Icon(
          _showPasswordText ? Icons.visibility_off : Icons.visibility,
        ),
      );
    } else {
      return null;
    }
  }
}
