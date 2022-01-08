import 'dart:async';
import 'validators.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  Stream<String> get email => _email.stream.transform(validatateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      CombineLatestStream([email, password], (_) => true);

  void Function(String)? get changeEmail => _email.sink.add;
  void Function(String)? get changePassword => _password.sink.add;

  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print('Email is $validEmail');
    print('Password is $validPassword');
  }

  dispose() {
    _email.close();
    _password.close;
  }
}

// final bloc = Bloc();
 