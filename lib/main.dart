import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/pages/auth/signIn.dart';
import 'package:instagram_clone_app1/pages/auth/signIn_provider.dart';
import 'package:instagram_clone_app1/pages/auth/signUp.dart';
import 'package:instagram_clone_app1/pages/auth/signUp_provider.dart';
import 'package:instagram_clone_app1/pages/main/comments/commen_page.dart';
import 'package:instagram_clone_app1/pages/main/main_page.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/creat_posts/create_post.dart';
import 'package:instagram_clone_app1/pages/main/post/creat_posts/create_post_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/posts/post.dart';
import 'package:instagram_clone_app1/pages/profile/profil.dart';
import 'package:instagram_clone_app1/pages/reaction/reaction_page.dart';
import 'package:instagram_clone_app1/pages/search/search_page.dart';
import 'package:instagram_clone_app1/pages/search/search_view.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSetup.setup;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppUtils.themeMode,
      builder: (context, value, child) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
          
            AppRoutes.signInPage: (_) => SignInPage.view,
            AppRoutes.signUpPage: (_) => SignUpPage.view,
            AppRoutes.createPost: (_) => CreatePost.show,
            AppRoutes.postPage: (_) => PostsPage.show,
            AppRoutes.commnet: (_) => CommentPage.show,
            AppRoutes.mainPage: (_) => MainPage.view,
            AppRoutes.searchPage: (_) => SearchPage.show,
            AppRoutes.searchView: (_) => SearchView.show,
            AppRoutes.profilePage: (_) => ProfilePage.show,
            AppRoutes.reactionpage: (_) => ReactionPage.show,
            
          
          },
          title: 'Flutter Demo',
          themeMode: value,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return MainPage.view;
                  } else {
                    return SignInPage.view;
                  }
                }
                return SignUpPage.view;
           }),
        ),
      ),
    );
  }
}
