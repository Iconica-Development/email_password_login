import 'package:flutter/material.dart';
import 'package:shell_email_password_login/shell_email_password_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final EmailPasswordFormController _loginFormController =
      EmailPasswordFormController();

  @override
  void dispose() {
    super.dispose();
    _loginFormController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            EmailPasswordForm(
              controller: _loginFormController,
              emailLabel: const Text('Email'),
              emailPrefixIcon: const Icon(Icons.person),
              passwordLabel: const Text(
                'Wachtwoord',
              ),
              passwordPrefixIcon: const Icon(Icons.password),
              inputDecoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none,
              ),
              togglePassword: true,
              showPasswordDefault: false,
              inputContainerBuilder: (context, input) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: input,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _loginFormController.submit();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
