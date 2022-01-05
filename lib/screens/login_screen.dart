import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/forgot_password.dart';
import '../screens/create_account.dart';
import '../screens/home_page_screen.dart';
import '../services/user_crud.dart';
import '../model/user.dart';
import '../utils/alerts.dart';
import '../services/sqlite_helper.dart';
import '../services/connection_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isVisible=false;
  bool _isVisible = false;
  bool _isLoading = false;
  var _isLoadingText='Login';
  bool passwordVisible=false;
  double _containerHeight=0;
  double _containerWidth=0;
  Color _btnColor=Colors.blue;
  userAPI API_USER = userAPI();
  var _alertMessage=Alert(message:'Please wait...',type:'success');
 bool hasConnection=false;
  String _contactText = '';

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _connectivitySubscription;
  late StreamSubscription InternetSubscription;
  int initCheck=0;



  @override
  initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);


    InternetSubscription=InternetConnectionChecker().onStatusChange.listen((event) {
      final hasConnection = event==InternetConnectionStatus.connected?
          setState(() {this.hasConnection = true;++initCheck; }):
           setState(() {this.hasConnection = false;++initCheck;} );

      if(initCheck>1 || this.hasConnection!=true) {
        setState(() {
          _isVisible = true;
        });
        _showAlert(false);
        _alertMessage = this.hasConnection == true ? Alert(
            message: 'You are back online', type: 'success') : Alert(
            message: 'There is no internet connection', type: 'danger');
      }
    });


  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    InternetSubscription.cancel();
    super.dispose();
  }


  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;

      print(_connectionStatus);
    });
  }



  _showAlert(status) async
  {
    Future.delayed(const Duration(seconds:7),(){
      if(mounted){
        setState(() {
          _isVisible=status;
        });
      }
    });
  }



  Future<int> _addUser(data) async {
    int getId= await SQLHelper.createUser(data['account_id'],data['names'],data['email'],data['avatar'],data['token']);
    return getId;
  }

  Future<List<Map<String, dynamic>>> _getUser(id) async {
    var response= await SQLHelper.getUser(id);
    return response;
  }

  void _passwordVisible() async
  {
        setState(() {
          passwordVisible=passwordVisible==true?false:true;

        });
  }

  void _loginUser() async
  {
    final data = User(
      email: emailController.text,
      password: passwordController.text,

    );

      setState(() {
        _btnColor = Colors.grey;
        _isLoading = true;
        _isLoadingText = 'Please wait ...';
        //print(check());
        _showAlert(false);
      });
      var sentData = await API_USER.loginUser(data);
      var getData = jsonDecode(sentData);
      print(getData);
      _isVisible = true;
      if (getData['status'] == 200) {
        //User userRecords = User.fromJson(jsonDecode(sentData));
        if (getData['user']['token'] != null) {
          _isLoading = false;
          _btnColor = Colors.blue;
          _isLoadingText = 'Login';

          final data = {
            'account_id': getData['user']['account_id'],
            'names': getData['user']['names'],
            'email': getData['user']['email'],
            'avatar': getData['user']['avatar'] == ''
                ? 'empty'
                : getData['user']['avatar'],
            'token': getData['user']['token']
          };
          final tableExist = await SQLHelper.checkTable('user');
          print(tableExist.length);
          final getUserById = await SQLHelper.getUser(data['account_id']);
          final record = getUserById.length;
          var avatar = getData['user']['avatar'] == ''
              ? 'empty'
              : getData['user']['avatar'];

          if (record == 0) {
            var getId = await _addUser(data);
          }
          else {
            var getRecords = getUserById.first;
            var updateUser = await SQLHelper.updateUser(
                getRecords['id'], getData['user']['account_id'],
                getData['user']['names'], getData['user']['email'], avatar,
                getData['user']['token']);
          }
          //final getUser=await SQLHelper.getUser(getData['user']['account_id']);


          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePageScreen(account_id:getData['user']['account_id'],curr_index:0),
          ));
        }
      }
      else if (getData['status'] == 400) {
        setState(() {
          _isVisible = true;
        });
        _showAlert(false);
        _isLoading = false;
        _btnColor = Colors.blue;
        _isLoadingText = 'Login';
        var errMessage = getData['errors'];
        var errors = '';
        for (var i = 0; i < errMessage.length; i++) {
          errors = '-' + errMessage[i]['msg'] + '\n' + errors;
        }
        _alertMessage = Alert(message: errors, type: 'danger');
      }
      else {
        setState(() {
          _isVisible = true;
        });
        _showAlert(false);
        _isLoading = false;
        _btnColor = Colors.blue;
        _isLoadingText = 'Login';
        _alertMessage =
            Alert(message: 'Invalid email or password', type: 'danger');
      }
  }

  @override
  Widget build(BuildContext context) {
    final double height =  MediaQuery.of(context).size.height;
    final double width =  MediaQuery.of(context).size.width;



    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top:70,right:5,left:5),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          border: OutlineInputBorder(
                          ),
                          labelText: 'Email',

                        ),

                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: passwordVisible==true?false:true,
                        controller: passwordController,
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible==false?Icons.visibility:Icons.visibility_off),
                            onPressed: () => _passwordVisible(),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),

                      ),
                    ),
                    Row(
                      children: [
                        FlatButton(
                          onPressed: (){
                            //forgot password screen
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder:
                                    (context) => ForgotScreen()
                                )
                            );
                          },

                          textColor: Colors.blue,
                          child: const Text('Forgot Password ?'),
                        ),
                        const Spacer(),
                        FlatButton(
                          textColor: Colors.blue,
                          child: const Text(
                            'Create new account',
                          ),
                          onPressed: (){
                            //forgot password screen
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder:
                                    (context) => const CreateAccountScreen()
                                )
                            );
                          },
                        )
                      ],
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: _btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red),
                          ),
                          child:  Row(
                            children:[
                              const Spacer(),
                              Visibility(visible:_isLoading,child: const Center(child: CircularProgressIndicator(strokeWidth: 10,)) ),
                              Text(_isLoadingText),
                              const Spacer()
                            ],
                          ) ,
                          onPressed: () => _loginUser(),
                        )),
                    Container(
                        height: 65,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red),
                          ),
                          child: Row(
                            children:  const [
                              Spacer(),
                              Image(image: AssetImage('assets/google.png'),width: 40,height: 40),
                              Text(' Login With Google'),
                              Spacer(),
                            ],
                          ),
                          onPressed: () {
                          },
                        )),
                  ],
                )),

            Visibility (
              visible: isVisible?true:false,
              child: Container(
                height: 400,
                margin: EdgeInsets.only(top: height*0.5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 25.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        15.0, // Move to right 10  horizontally
                        15.0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: ListView(
                  children:  [
                    Row(
                      children: [
                        IconButton(
                          icon:  const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              isVisible=isVisible==true?false:true;
                            });
                          },
                          color: Colors.blue,
                        ),
                        const Spacer(),
                         const Text(
                          'Login with Google',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w200,
                              fontSize: 30),

                        ),
                        Spacer(),
                      ],
                    ),


                  ],
                ),
              )
            ),
            Container(
              padding: EdgeInsets.only(top:height*0.94),
              child:Visibility (
                visible:_isVisible,
                child:_alertMessage,
              ),
            ),



          ],
        ));
  }
}
