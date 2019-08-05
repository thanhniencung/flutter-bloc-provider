import 'package:flutter/material.dart';
import 'package:flutter_app_c4f_mvvm/home/home_view.dart';
import 'package:provider/provider.dart';
import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ChangeNotifierProvider(
        builder: (_) => LoginBloc(),
        child: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.addListener(() {
      LoginBloc.of(context).emailSink.add(emailController.text);
    });

    passController.addListener(() {
      LoginBloc.of(context).passSink.add(passController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var loginBloc = LoginBloc.of(context);
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<String>(
              stream: loginBloc.emailStream,
              builder: (context, snapshot) {
                return TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: "example@gmail.com",
                    labelText: "Email *",
                    errorText: snapshot.data,
                  ),
                );
              }),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<String>(
              stream: loginBloc.passStream,
              builder: (context, snapshot) {
                return TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: "Password *",
                    errorText: snapshot.data,
                  ),
                );
              }),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 200,
            height: 45,
            child: StreamBuilder<bool>(
                stream: loginBloc.btnStream,
                builder: (context, snapshot) {
                  return RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: snapshot.data == true
                        ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }
                        : null,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
