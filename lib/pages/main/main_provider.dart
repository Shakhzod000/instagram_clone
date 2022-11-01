import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone_app1/models/user_model.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';

import '../../utils/app_route.dart';

class MainProvider with ChangeNotifier {
  final CupertinoTabController? cupertinoTabController = CupertinoTabController();
  int? _currentIndex = 0;
  UserModel? _user;
  String?  _imageUrl;
  UserModel? _selectedUser;
  
   void getUser({required String? uid}) async {
    try {
      _selectedUser = await AuthSrc.getSelectedUser(userUid: uid);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.signInPage, (route) => false);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

void getUserAvatar()async{
  try{
   _user = await AuthSrc.getCurrentuser;
   _imageUrl = _user!.photoAvatarUrl;  
  }catch (e){
    log(e.toString());
  }
}


  void changeIndex(int? index) {
    _currentIndex = index;
    cupertinoTabController!.index = index!;
    log(cupertinoTabController!.index.toString());
    notifyListeners();
  }

  int? get currentIndex => _currentIndex;
  String? get  imageurl => _imageUrl;
 UserModel? get user => _user;
   UserModel? get selectedUser => _selectedUser;

}