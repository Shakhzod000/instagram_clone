
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/models/user_model.dart';
import 'package:instagram_clone_app1/pages/search/search_provider.dart';
import 'package:instagram_clone_app1/pages/search/widget/user_widget.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider(
    create: (_) => SearchProvider(),
    child:const  SearchPage(),
  );


  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.h),
          child: AppBar(
            toolbarHeight: 60.h,
             leading: IconButton(
              onPressed: (){
                if(Navigator.canPop(context)){
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                }
              },
               icon:  Icon(Icons.arrow_back_outlined,
               color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
               )),
                leadingWidth: 30.h,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Consumer<SearchProvider>(
                  builder: (context,providerValue, _){ 
                    return CupertinoTextField(
                      onChanged: (value){
                        if(value.isNotEmpty){
                          providerValue.updateStateSearch();
                        }
                      },
                      controller: providerValue.searchController,
                    prefix: Padding(
                      padding:EdgeInsets.only(left: 11.w),
                      child:  Icon(CupertinoIcons.search,
                      size: 18.w,
                      color: Theme.of(context).copyWith(
                        focusColor:
                         const Color(0xFF8E8E93)).focusColor,
                      ),
                       ),
                       placeholder: 'Search',
                       placeholderStyle: Theme.of(context)
                       .textTheme
                       .displaySmall!
                       .copyWith(color: const Color(0xFF8E8E93), fontSize: 16.sp),
                
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: Theme.of(context)
                        .cupertinoOverrideTheme!.barBackgroundColor 
                       ),
                  );
             }),
          ),
          ),
            
          body: Consumer<SearchProvider>(
              builder: (context, searchValue, _) {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: Firesrc.firebaseFirestore
                  .collection('users')
                  .where('username',
                  isGreaterThanOrEqualTo: searchValue.searchController.text)
                  .orderBy('username', descending: false)
                  .get()
                  .asStream(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                       
                    if(!snapshot.hasData){
                      return const  Center(child: CupertinoActivityIndicator(),);
                    }
                    if(snapshot.hasError){
                      return const Center(child: Text('You app has an error'),);
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index){
                        UserModel? user = UserModel.fromDocumentSnapshot(
                         snapshot.data!.docs[index],
                        );
                      return Userwidget(onPress: (){
                        
                      }, user: user); 
                      },
                      
                    );
                  },
                );
              }
          ),
    );
  }
}