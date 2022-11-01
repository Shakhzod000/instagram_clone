
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/creat_posts/create_post_provider.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
 
  const CreatePost({Key? key}) : super(key: key);
  static Widget get show => MultiProvider(
    providers: [
      ChangeNotifierProvider<CreatPostProvider>(
        create: (context) => CreatPostProvider(),
        child: const CreatePost(),
      )
    ],
    child: const CreatePost(),
  );

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.h),
        child: AppBar(
          leading: Consumer2<MainProvider, CreatPostProvider>(
            builder: (context, mainProvidervalue, creatPostvalue, _) =>
            IconButton(
              onPressed:(){
                creatPostvalue.restore();
                mainProvidervalue.changeIndex(0);
                log(mainProvidervalue.currentIndex.toString());
              },
               icon: Icon(Icons.clear,
               color: Theme.of(context)
               .bottomNavigationBarTheme
               .selectedItemColor,))
              
          
          ),
          title: Text('New post',
          style:Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: .0,
          actions: [
            Consumer<CreatPostProvider>(
            builder: (context, postValue, _) =>  
            IconButton(
              onPressed: ()=> postValue.showPostCreationType(context),
               icon:  Icon(Icons.add_box_outlined,
               color: Theme.of(context)
               .bottomNavigationBarTheme
               .selectedItemColor,
               )),

            ),
            SizedBox(width: 15.w),
          ],
        ),
      ),
  body:
   Consumer2<CreatPostProvider, MainProvider>(
    builder: (context, cratePostValue, mainProvider, _) => SafeArea(
      child: SizedBox(
        width: 375.w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 375.h,
                width: 375.w,
                child: cratePostValue.imageFile == null
                ? const SizedBox.shrink()
                :Image.file(
                  cratePostValue.imageFile!,
                  fit: BoxFit.cover,
                )
              ),
              
               SizedBox(height: 20.h,),
        
               if(cratePostValue.imageFile != null)
               Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: cratePostValue.descriptionController,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: 'description',
                    hintStyle: Theme.of(context).textTheme.titleMedium,
                    border: UnderlineInputBorder(
                      borderSide:BorderSide(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor)
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor
                      )
                    )
                  ),
                ),
                ),
                if(cratePostValue.imageFile != null)
                CupertinoButton(
                  child: const Text('Publish post'),
                   onPressed: ()=> cratePostValue.publishPost(func: (index) => mainProvider.changeIndex(index)
                   
                   )
                   )
            ],
          ),
        ),
      ),
    ),
  ),
    );
  }
}