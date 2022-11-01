

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/data/app_data.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/creat_posts/create_post.dart';
import 'package:instagram_clone_app1/pages/main/post/posts/post.dart';
import 'package:instagram_clone_app1/utils/app_constant.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
   static Widget get view => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MainProvider(),
      )
    ],
    child: const MainPage(),
   );
   
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  

  @override
  void didChangeDependencies() {
    context.read<MainProvider>().getUserAvatar();
    if (kDebugMode) {
      print("did Change Dep");
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, mainValue, _) {
      return CupertinoTabScaffold(
        controller: mainValue.cupertinoTabController,
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        tabBar: CupertinoTabBar(
          onTap: (newIndex) => mainValue.changeIndex(newIndex),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                CupertinoIcons.home,
              ),
              activeIcon: Icon(
                CupertinoIcons.home,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
                icon: const Icon(CupertinoIcons.search)),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_box_outlined),
              activeIcon: Icon(
                Icons.add_box_outlined,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  CupertinoIcons.heart_fill,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
                icon: const Icon(CupertinoIcons.heart)),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(2.w),
                height: 29.w,
                width: 29.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.w, color: Colors.transparent)),
                child: mainValue.imageurl == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(AppConstants.avatar),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              mainValue.imageurl!,
                            ),
                          ),
                        ),
                      ),
              ),
              activeIcon: Container(
                padding: EdgeInsets.all(2.w),
                height: 29.w,
                width: 29.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1.w, color: Theme.of(context).focusColor)),
                child: mainValue.imageurl == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(AppConstants.avatar),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              mainValue.imageurl!,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        tabBuilder: (context, index) => Material(
            color: Theme.of(context).backgroundColor, child: pageList[index]),
      );
    });
  }
}