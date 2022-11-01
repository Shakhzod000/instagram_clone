import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static void showDialog(BuildContext context, {required String? msg}){
    showCupertinoDialog(
      context: context,
     builder: (context) => CupertinoAlertDialog(
      title: const Text('Input erroe'),
      content:Text(msg!),
      actions: [
        CupertinoDialogAction(
        child: const Text('ok'),
        onPressed: (){
          Navigator.of(context).pop();
        },
        )
      ],
     )
     );
  }

static String? getDuration(String? dateTime){
  Duration? duration = 
  DateTime.now().difference(DateTime.tryParse(dateTime!)!);
  int? day = duration.inDays;
  int? hours = duration.inHours;
  int? min = duration.inMinutes;
  int? sec = duration.inSeconds;

  if(day>=1){
    return '$day days ago';
  }else if(hours >= 1){
    return '$hours hours ago';
  }else if(min>= 1){
    return '$min minutes ago';
  }else{
    return '$sec seconds ago';
  }
}


   static void themeChanger() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}