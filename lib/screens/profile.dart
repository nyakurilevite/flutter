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
import '../utils/bottom_navigation.dart';


class ProfileScreen extends StatefulWidget {
  String account_id;
  int curr_index;
  ProfileScreen({Key? key,required this.account_id,required this.curr_index}) : super(key: key);

  @override
  _State createState() => _State(this.account_id,this.curr_index);
}

class _State extends State<ProfileScreen> {
  String account_id;
  int curr_index;
  _State(this.account_id,this.curr_index);

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
  var getUser;
  var _userName;
  var _avatar;

  //**************************************LOGIN WITH GOOGLE**********************************************
  @override
  void initState() {
    _checkConnection();
    _getUserInfo();
    super.initState();
  }

  Future<bool> _connectivity() async{
    bool response=await ConnectionUtil.hasInternetInternetConnection();
    return response;
  }

  _checkConnection() async{
    if(await _connectivity()==false) {
      setState(() {
        _isVisible = true;
      });
      _showAlert(false);
      _alertMessage =Alert(message: 'There is no internet connection', type: 'danger');
    }
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

    if (await _connectivity()==false) {
      _checkConnection();
    }
    else {
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


          /*Navigator.push(
              context, MaterialPageRoute(builder: (context) => //HomePageScreen(),
              settings: RouteSettings(
                arguments: getData['user']['account_id'],
              )
          ));*/
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
  }

  void _getUserInfo() async
  {

    getUser=await SQLHelper.getUser(this.account_id);
    setState(() {
      var getRecords = getUser.first;
      _userName=getRecords['names'];
      _avatar=getRecords['avatar'];
    });

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
                  children:  [
                      Center(
                       child: Column(
                           children: [
                             CircleAvatar(
                                 radius: 50,
                                 backgroundImage: NetworkImage(
                                     _avatar=='empty'?'https://cdn4.iconfinder.com/data/icons/eon-ecommerce-i-1/32/user_profile_man-1024.png':_avatar.toString())
                             ),
                             const SizedBox(height: 20,),
                             Row(
                               children: [
                                 Spacer(),
                                 Text('@'+_userName.toString(),
                                     style:const TextStyle(
                                         fontSize: 20,
                                         fontWeight: FontWeight.w300
                                     )
                                 ),
                                 IconButton(
                                     onPressed:(){

                                       },
                                     icon:Icon(Icons.edit)),
                                 Spacer()
                               ],
                             ),
                             const SizedBox(height: 30,),
                             Row(
                               children: [
                                 const Spacer(),
                                  Column(
                                    children: const [
                                      Text('7',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10,),
                                      Text('Following',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300)),
                                    ],
                                  ),
                                  Container(height: 40, child: VerticalDivider(color: Colors.black)),
                                 Column(
                                   children: const [
                                     Text('2',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                     SizedBox(height: 10,),
                                     Text('Followers',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300)),
                                   ],
                                 ),
                                 Container(height: 40, child: VerticalDivider(color: Colors.black)),
                                 Column(
                                   children: const [
                                     Text('0',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                     SizedBox(height: 10,),
                                     Text('Likes',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300)),
                                   ],
                                 ),
                                  const Spacer()
                               ],
                             ),
                             const SizedBox(height: 30),

                               ],
                             )


                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        //shadowColor: Colors.greenAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Colors.black),

                        ),
                        minimumSize: Size(100, 40), //////// HERE
                      ),
                        child:  Row(
                          children:const [
                            Spacer(),
                            Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold),),
                            Spacer()
                          ],
                        ) ,
                        onPressed: () {

                        },
                      ),

                  ],
                         ),
                     ),
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
            Container(
              //padding: EdgeInsets.only(top:60)
              decoration: const BoxDecoration(
                border:Border(
                  bottom: BorderSide( //                   <--- left side
                    color: Colors.black,
                    width: 1.0,
                  ),
                )
              ),
                height:60,
                child:Row(
                  children: [
                    IconButton(onPressed:()=>{}, icon:const Icon(Icons.group_add)),
                    const Spacer(),
                    Text(_userName.toString(),
                        style:const TextStyle(
                            color: Colors.blue,
                            fontSize: 20) ),
                    const Spacer(),
                    IconButton(onPressed:()=>{}, icon:const Icon(Icons.more_vert)),
                  ],
                ),
                //color:Colors.transparent
            ),

                  ],
                ),
        bottomNavigationBar: BottomMenu(account_id:account_id,curr_index: 4,)
          );

  }
}
