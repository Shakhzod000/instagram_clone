

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileProvider with ChangeNotifier{
  final ScrollController scrollController = ScrollController();

  bool? showTabbar = false;

  void onChangeScroll(){
    scrollController.addListener(() {
      if(scrollController.position.pixels.h >=363){
        showTabbar =true;
        notifyListeners();
      }else if(scrollController.position.pixels.h < 363){
        showTabbar = false;
        notifyListeners();
      }
    });
  }
}