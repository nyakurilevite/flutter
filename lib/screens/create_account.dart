import 'package:flutter/material.dart';
import '../utils/text_field.dart';
import '../screens/login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CreateAccountScreen> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => LoginScreen()
                  )
              );
            },
            color: Colors.blue,
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                        padding: const EdgeInsets.all(10),
                        child:TextField(
                          controller: fnameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            labelText: 'Enter first name',
                          ),

                        ),
                ),
                Container(
                        padding: const EdgeInsets.all(10),
                        child:TextField(
                          controller: lnameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                            ),
                            labelText: 'Enter last name',
                          ),

                        ),
                    ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: 'Enter your email',
                    ),

                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your password',
                    ),

                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm password',
                    ),

                  ),
                ),
                Container(
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        //side: BorderSide(color: Colors.red),
                      ),
                      child: const Text('Create Account'),
                      onPressed: () {

                      },
                    )),
              ],
            )));
  }
}