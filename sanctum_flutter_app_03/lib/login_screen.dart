import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sanctum_flutter_app_03/service/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  late String _email;

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // _emailController.text = 'admin@admin.com';
    // _passwordController.text = 'pwdpwd';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //final form = _formkey.currentState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value == '' ? 'Please enter valid email' : null),
              TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value == '' ? 'Please enter valid password' : null),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                minWidth: double.infinity,
                color: Colors.blue,
                child: Text('ເຂົ້າສູ່ລະບົບ'),
                onPressed: () {
                  Map creds = {
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'device_name': 'mobile',
                  };
                  final form = _formkey.currentState;
                  if (form != null && !form.validate()) {
                    print("form error!");
                    return;
                  }

                  Provider.of<Auth>(context, listen: false).login(creds);
                  // CheckLogin();
                  // Navigator.pop(context);
                  //print(status);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void CheckLogin() async {
  //   String? token = await storage.read(key: 'token');
  //   print(token);
  //   if (token != null) {
  //     Provider.of<Auth>(context, listen: false)
  //         .tyToken(token: token.toString());
  //     Navigator.pop(context);
  //   }
  // }
}
