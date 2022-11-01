
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';

abstract class SignInProviderRepository{
  void onInit();
  void Ondispose();
} 

class SignInProvider extends SignInProviderRepository with ChangeNotifier{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool? isloading = false;

  void signIn (BuildContext context) async{
    if(passwordController.text.length<7){
       AppUtils.showDialog(context, msg: 'Password 7 tadan kam');
    }
   try{
    if(usernameController.text.isEmpty || passwordController.text.isEmpty){
      return;
    }
    isloading =true;
    notifyListeners();
    final UserCredential? userCredential = await AuthSrc.signIn(username: usernameController.text, password: passwordController.text);
    if(userCredential != null){
      isloading =false;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainPage, (route) => false);
      notifyListeners();
    }
   }catch (e){
    log(e.toString());
   }
  }


  void Ondispose(){
    usernameController.dispose();
    passwordController.dispose();
  }

  void onInit(){

  }
}