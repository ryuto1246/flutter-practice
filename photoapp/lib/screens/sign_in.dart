import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/screens/photo_list.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: formInner(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> formInner() {
    return [
      Text(
        'Photo App',
        style: Theme.of(context).textTheme.headline4,
      ),
      const SizedBox(height: 16),
      emailField(),
      const SizedBox(height: 16),
      passwordField(),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _onSignIn(),
          child: const Text('ログイン'),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _onSignUp(),
          child: const Text('新規登録'),
        ),
      ),
    ];
  }

  TextFormField emailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'メールアドレス'),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value?.isEmpty == true) {
          return 'メールアドレスを入力してください。';
        }

        return null;
      },
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'パスワード'),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (String? value) {
        if (value?.isEmpty == true) {
          return 'パスワードを入力してください。';
        }
        return null;
      },
    );
  }

  Future<void> _onSignIn() async {
    try {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PhotoListScreen()),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> _onSignUp() async {
    try {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      final String email = _emailController.text;
      final String password = _passwordController.text;

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const PhotoListScreen(),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PhotoListScreen()),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }
}
