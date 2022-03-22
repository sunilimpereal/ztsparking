import 'dart:async';

class ValidationMixin {
  final validatorEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (!email.contains('@')) {
      sink.addError('Please Enter Valid Email');
    } else if (email.contains('@') && !email.toLowerCase().contains("parking")) {
      sink.addError('User not Permitted');
    } else if (email.contains(' ')) {
      sink.addError('Please remove space');
    } else {
      sink.add(email);
    }
  });
  final validatorPassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (password, sink1) {
    if (password.length < 1) {
      sink1.addError('Please Enter Valid password');
    } else {
      sink1.add(password);
    }
  });
  final validatorNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (number, sink1) {
    if (number.length > 10) {
      sink1.addError('Please Enter Valid number');
    } else {
      sink1.add(number);
    }
  });
  final validatorMobile =
      StreamTransformer<String, String>.fromHandlers(handleData: (mobile, sink) {
    if (mobile.contains(' ')) {
      sink.addError('Enter valid Mobile number');
    } else if (mobile.contains(r'a-z')) {
      sink.addError('Enter valid Mobile number');
    } else {
      sink.add(mobile);
    }
  });
  final validatorbaseUrl = StreamTransformer<String, String>.fromHandlers(handleData: (url, sink1) {
    final urlRegExp = new RegExp(
        r"((http:www\.)|(http:www\.)(https:\/\/)|(http:\/\/))|[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    // if (!Uri.parse(url).isAbsolute) {
    if (!urlRegExp.hasMatch(url)) {
      sink1.addError('Please Enter Valid Url');
    } else {
      sink1.add(url);
    }
  });
  final validatorticketCode =
      StreamTransformer<String, String>.fromHandlers(handleData: (code, sink1) {
    if (code.length != 3 && code.contains(RegExp(r'[0-9]'))) {
      sink1.addError('Please Enter Valid ticket Code');
    } else {
      sink1.add(code);
    }
  });
}
