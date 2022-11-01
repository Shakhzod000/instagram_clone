import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/posts/post_provider.dart';
import 'package:instagram_clone_app1/pages/main/post/posts/widget/post_item.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:provider/provider.dart';

import '../../../../models/post_model.dart';

class PostsPage extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider<PostProvider>(
        create: (_) => PostProvider(),
        child: const PostsPage(),
      );
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: Text(
              'Instagram',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 30.sp),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: .0,
            actions: [
              Consumer<PostProvider>(
                builder: (context, postValue, _) => IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                ),
              ),
              Consumer2<PostProvider,MainProvider>(
                builder: (context, value, valueMain, child) => IconButton(
                    onPressed: () {
                      valueMain.logout(context);
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedItemColor,
                    )),
              ),
              SizedBox(
                width: 15.w,
              ),
            ],
          ),
        ),
        body: Consumer<PostProvider>(
          builder: (context, valuePosts, child) => FirestoreListView<Map<String,dynamic>>(
            shrinkWrap: true,
            query: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished', descending: true),
            itemBuilder: (context, doc) {
              if (doc.data().isEmpty) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (!doc.exists) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              
              PostModel? post = PostModel.fromDocumentSnapshot(doc);

              // valuePosts.getCommentLength(postId: post.postId);
               return PostItem(
                post: post,
                fullCommentLength: post.comments!,
                addLike: () => valuePosts.addLike(post: post),
                removeLike: () => valuePosts.removeLike(post: post),
                liked: Firesrc.isLiked(myPost: post),
              );
            },
          ),
        ));
  }
}