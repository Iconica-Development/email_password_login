import 'package:flutter/material.dart';
import 'package:shell_email_password_login/shell_email_password_login.dart';

/// A basic widget containing an email and password login form
/// 
/// The main use case of this widget is facilitating the core UI functionality
/// of a login screen based on email and password login.
/// 
/// The inputs in this widget can be rewritten 
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
    this.controller,
    this.onSubmit,
    this.initialData,
  }) : super(key: key);

  final String Function(EmailPasswordFormValidationError error)?
      getValidationError;
  final EdgeInsets? padding;
  final EmailPasswordFormController? controller;
  final Widget? emailPrefixIcon;
  final Widget? emailLabel;
  final Widget? passwordPrefixIcon;
  final Widget? passwordLabel;
  final bool togglePassword;
  final bool showPasswordDefault;
  final TextStyle? inputTextStyle;
  final InputDecoration? inputDecoration;
  final EmailPasswordFormData? initialData;
  final void Function(EmailPasswordFormData data)? onSubmit;
  final Widget Function(BuildContext context, Widget input)
      inputContainerBuilder;

  static Widget _defaultInputContainerBuilder(BuildContext _, Widget input) =>
      input;

  @override
  State<EmailPasswordForm> createState() => EmailPasswordFormState();
}

class EmailPasswordFormState extends State<EmailPasswordForm> {
  late bool _showPasswordText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late EmailPasswordFormData data;

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _showPasswordText = widget.showPasswordDefault;
    widget.controller?.attach(this);
    if (widget.initialData != null) {
      data = widget.initialData!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                controller: _emailController,
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
                controller: _passwordController,
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

  void setData(EmailPasswordFormData data) {
    _emailController.text = data.email;
    _passwordController.text = data.password;
    setState(() {
      this.data = data;
    });
  }

  EmailPasswordFormData? save() {
    var form = _formKey.currentState;
    if (form != null && form.validate()) {
      data = EmailPasswordFormData();
      form.save();
      widget.onSubmit?.call(data);
      return data;
    }
    return null;
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
