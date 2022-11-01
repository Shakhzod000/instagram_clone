
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app1/pages/auth/signIn_provider.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';

abstract class SingUpProviderRepository{
  void onInit();
  void Ondispose();
}

class SignUpProvider extends SignInProviderRepository with ChangeNotifier{
  final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
final _imagePicker = ImagePicker();

final globalKeyForFromField = GlobalKey<FormState>();
File? _file;
bool? isloading =false;


 @override
  void Ondispose(){
     usernameController.dispose();
     emailController.dispose();
     confirmPasswordController.dispose();
     passwordController.dispose();
     bioController.dispose();
     
  }

  void upLoadImageAvatar() async{
    try{
      var xFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      _file = File(xFile!.path);
      notifyListeners();
    }catch (e){
      log(e.toString());
    }
  }

 void signUp(BuildContext context)async{
     FocusScope.of(context).unfocus();
    RegExp exp = RegExp(r"^[a-z0-9](\.?[a-z0-9]){5,}@g(oogle)?mail\.com$");
    if(!exp.hasMatch(emailController.text)){
      AppUtils.showDialog(context, msg: "Gmail kiritishda xatolik bor");
      return;
    }

     if (passwordController.text.length < 7) {
      AppUtils.showDialog(context, msg: 'Password 7 tadan kam');
      return;
    }
    if(_file == null){
      AppUtils.showDialog(context, msg: 'Rasm yuklandi');
    }
    isloading =true;
    notifyListeners();

  try{
    if(
      passwordController.text.isEmpty ||
      emailController.text.isEmpty ||
      confirmPasswordController.text.isEmpty ||
      usernameController.text.isEmpty
      ) return;
      if(passwordController.text.trim() != confirmPasswordController.text.trim()){
        return;
      }

      var userCreated = await AuthSrc.signUp(
        username: usernameController.text.trim(),
         email: emailController.text.trim(),
          password: passwordController.text.trim(),
           bio: bioController.text.trim(),
            imageFile: _file);
            if(userCreated!){
               isloading =false;
               // ignore: use_build_context_synchronously
               Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainPage, (route) => false);
            }
            isloading = false;
            notifyListeners();
  } catch (e){
    log(e.toString());
  }
 }

  
  @override
  void onInit() {
    // TODO: implement Ondispose
  }


 File? get imageFile => _file;
}