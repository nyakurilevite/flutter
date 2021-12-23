import 'dart:convert';

import '../model/user.dart';
import '../services/url.dart';
import 'package:http/http.dart';

class userAPI {

  var url= apiUrl.API_URL;

  Future<List<User>> getUsers(String token) async {
    Response res = await get(Uri.parse(url+"users/"),
        headers: {'Authorization': 'Bearer $token'}
    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<User> user = body.map((dynamic item) => User.fromJson(item)).toList();
      return user;
    }
    else if  (res.statusCode == 401) {
      throw "JWT_EXPIRED";
    }
    else {
      throw "FAILED_TO_LOAD_USERS";
    }
  }

  Future<String> getUsersByToken(String token) async {
    final response = await get(Uri.parse(url+'whoami/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      throw "FAILED_TO_LOAD_USERS";
    }
  }

  Future<String> createUser(User user) async {
    Map data = {
      'username': user.username,
      'names': user.names,
      'phone_number': user.phone_number,
      'password':user.password,
      'confirm_password':user.confirm_password,
      'email':user.email,

    };

    final Response response = await post(Uri.parse(
      url+'users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    String statuscode="${response.statusCode}";
    return statuscode;
  }

  Future<String> forgotPassword(User user) async {
    Map data = {
      'email': user.email,
    };

    final Response response = await post(Uri.parse(url +'users/forgot/password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    String statuscode = "${response.statusCode}";
    return statuscode;

  }
  Future<String> changePassword(User user,String token) async {
    Map data = {
      'password': user.password,
      'confirm_password': user.confirm_password
    };

    final Response response = await post(Uri.parse(
      url+'users/reset/password/'+ token),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    String statuscode="${response.statusCode}";
    return statuscode;
  }

  Future<String> confirmAccount(String token) async {
    final Response response = await post(
        Uri.parse(url+'users/confirm/'+ token),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: jsonEncode(data),
    );
    String statuscode="${response.statusCode}";
    return statuscode;
  }
  Future<String> verificationCode(String token) async {
    final Response response = await get(
        Uri.parse(url+'users/verification_code/'+ token),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: jsonEncode(data),
    );
    if(response.statusCode==200) {
      return response.body;
    }
    else {
      throw "FAILED_TO_LOAD_USERS";
    }
  }

  Future<String> loginUser(User user) async {
    Map data = {
      'password':user.password,
      'email':user.email,
    };

    final Response response = await post(
        Uri.parse(url+'users/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
      return response.body;
  }

  Future<User> updateUser(String account_id, User user) async {
    Map data = {
      'username': user.username,
      'names': user.names,
      'phone_number': user.phone_number,
      'password':user.password,
      'email':user.email,
    };

    final Response response = await post(
        Uri.parse(url+'users/account_id/'+ account_id) ,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update a case');
    }
  }

  Future<void> deleteUser(String id,String token) async {
    Response res = await delete(
        Uri.parse(url+'users/id/'+ id) ,
        headers: {'Authorization': 'Bearer $token'}
    );

    if (res.statusCode == 200) {
      print("USER_DELETED");
    } else {
      throw Exception('FAILED_TO_DELETE_USER');
    }
  }

}