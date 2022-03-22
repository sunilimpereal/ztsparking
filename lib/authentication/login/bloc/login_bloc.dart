import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ztsparking/authentication/login/bloc/validation_mixin.dart';

class LoginBloc with ValidationMixin {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
    final _baseUrl = BehaviorSubject<String>();
  final _ticketCode = BehaviorSubject<String>();

  //gettters
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changebaseUrl => _baseUrl.sink.add;
    Function(String) get changeticketCode => _ticketCode.sink.add;


  //streams
  Stream<String> get email => _email.stream.transform(validatorEmail);
  Stream<String> get password => _password.stream.transform(validatorPassword);
  Stream<String> get baseUrl => _baseUrl.stream.transform(validatorbaseUrl);
  Stream<String> get ticketCode => _ticketCode.stream.transform(validatorticketCode);
  

  Stream<bool> get submitValidForm => Rx.combineLatest2(email, password, (e, n) => true);
  Stream<List<String>> get validateFormStream => Rx.combineLatestList(
        [
          email,
          password,
        ],
      );
        Stream<List<String>> get validateSettingsFormStream => Rx.combineLatestList(
        [
          baseUrl,
          ticketCode
        ],
      );

  dispose() {
    _email.close();
        _baseUrl.close();

  }
}

class LoginProvider extends InheritedWidget {
  final bloc = LoginBloc();
  LoginProvider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<LoginProvider>())!.bloc;
  }
}
