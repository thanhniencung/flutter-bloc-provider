import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_app_c4f_mvvm/helper/validation.dart';

class LoginViewModel {
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    sink.add(Validation.validateEmail(email));
  });

  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    sink.add(Validation.validatePass(pass));
  });

  Stream<String> get emailStream =>
      _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  LoginViewModel() {
    Observable.combineLatest2(_emailSubject, _passSubject, (email, pass) {
      return Validation.validateEmail(email) == null &&
          Validation.validatePass(pass) == null;
    }).listen((enable) {
      btnSink.add(enable);
    });
  }

  dispose() {
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
