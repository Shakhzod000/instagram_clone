import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/models/post_model.dart';
import 'package:instagram_clone_app1/pages/search/user_widget/user_widget.provider.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../utils/app_constant.dart';
import '../../main/main_provider.dart';
import '../../profile/widget/info_widget.dart';
import '../../profile/widget/story_widget.dart';

class UserPageView extends StatefulWidget {
  static Widget get show => MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewProvider>(
            create: (_) => UserViewProvider(),
            lazy: false,
          ),
          ChangeNotifierProvider<MainProvider>.value(value: MainProvider())
        ],
        child: const UserPageView(),
      );
  const UserPageView({super.key});

  @override
  State<UserPageView> createState() => _UserPageViewState();
}

class _UserPageViewState extends State<UserPageView> {
  late String? userId;
  @override
  void didChangeDependencies() {
    context.read<UserViewProvider>().onChangeScroll();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (args.containsKey('uid') && args['uid'] != null) {
      userId = args['uid'];
      log(args['uid']);
      context.read<MainProvider>().getUser(uid: args['uid']);
      log(context.read<MainProvider>().selectedUser.toString());
      context.read<UserViewProvider>().checkFollowing(
          userId: args['uid'], myUid: AuthSrc.firebaseauth.currentUser!.uid);
      setState(() {});
    }
    log('INITEDDD');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewProvider, MainProvider>(
        builder: (context, userValue, mainValue, _) {
      if (mainValue.selectedUser == null) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      if (userValue.isFollowed == null) {
        return const Center(child: CupertinoActivityIndicator());
      }
      return DefaultTabController(
        length: 2,
        child: NestedScrollView(
            controller: userValue.scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    leading: IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    elevation: .0,
                    bottom: userValue.showTabBar!
                        ? TabBar(
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                              width: 1.h,
                              color: Theme.of(context).focusColor,
                            )),
                            tabs: [
                                Tab(
                                  child: Icon(
                                    Icons.grid_on_rounded,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                                Tab(
                                  child: Icon(
                                    Icons.perm_contact_cal_rounded,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                              ])
                        : PreferredSize(
                            preferredSize: Size.fromHeight(.0.h),
                            child: const SizedBox.shrink()),
                    title: ColoredBox(
                      color: Theme.of(context).appBarTheme.backgroundColor!,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.lock_fill,
                            size: 12.w,
                            color: Theme.of(context).focusColor,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            mainValue.selectedUser!.username ?? "user",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 12.w,
                            color: Theme.of(context).focusColor,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: true,
                    flexibleSpace: const FlexibleSpaceBar(),
                  ),
                  SliverToBoxAdapter(
                    child: ColoredBox(
                      color: Theme.of(context).appBarTheme.backgroundColor!,
                      child: SizedBox(
                        width: 348.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 11.w, right: 28.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 96.w,
                                    height: 96.w,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1.5.w,
                                            color: const Color(0xFF48484A))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(43.w),
                                      child: CachedNetworkImage(
                                        imageUrl: mainValue
                                                .selectedUser!.photoAvatarUrl ??
                                            AppConstants.defaulImage,
                                        fit: BoxFit.cover,
                                        width: 86.w,
                                        height: 86.h,
                                        errorWidget: (context, url, error) =>
                                            const SizedBox.shrink(),
                                        placeholder: (context, url) =>
                                            const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                  //? posts
                                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                      stream: Firesrc.firebaseFirestore
                                          .collection('posts')
                                          .get()
                                          .asStream(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Center(
                                            child: Text('you hav an error'),
                                          );
                                        }

                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        }

                                        final data = snapshot.data;
                                        var list = data!.docs
                                            .where((e) =>
                                                e.data()['userId'] == userId)
                                            .toList();

                                        log("data::${list.length}");
                                        return InfoWidget(
                                            count: list.length, title: 'Posts');
                                      }),

                                  InfoWidget(
                                      count: mainValue
                                          .selectedUser!.followers!.length
                                          .toInt(),
                                      title: 'Followers'),
                                  InfoWidget(
                                      count: mainValue
                                          .selectedUser!.following!.length
                                          .toInt(),
                                      title: 'Followings'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            //? username
                            Flexible(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 11.w, right: 28.w),
                                child: Text(
                                  mainValue.selectedUser!.username ?? 'user',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            //? description
                            Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 28.w),
                              child: Text(
                                mainValue.selectedUser!.bio ?? 'bio',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            //?button

                            StreamBuilder<dynamic>(
                                stream: Firesrc.firebaseFirestore
                                    .collection('users')
                                    .doc(userId)
                                    .get()
                                    .asStream(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('you hav an error'),
                                    );
                                  }

                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }

                                  UserModel? user =
                                      UserModel.fromDocumentSnapshot(
                                          snapshot.data);

                                  if (userId ==
                                      AuthSrc.firebaseauth.currentUser!.uid) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 11.w, right: 28.w),
                                      child: SizedBox(
                                        height: 30.h,
                                        width: 343.w,
                                        child: CupertinoButton(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          color:
                                              Theme.of(context).backgroundColor,
                                          child: Text(
                                            'edit profile',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    fontSize: 13.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  }
                                  if (user.followers!.contains(
                                      AuthSrc.firebaseauth.currentUser!.uid)) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 11.w, right: 28.w),
                                      child: SizedBox(
                                        height: 30.h,
                                        width: 343.w,
                                        child: CupertinoButton(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          color: const Color(0xFF000000),
                                          child: Text(
                                            'Unfollow',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    fontSize: 13.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          onPressed: () async {
                                            userValue.unFollow(userId: userId);
                                          },
                                        ),
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 11.w, right: 28.w),
                                    child: SizedBox(
                                      height: 30.h,
                                      width: 343.w,
                                      child: CupertinoButton(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0),
                                        color: const Color(0xFF3797EF),
                                        child: Text(
                                          'Follow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: () async {
                                          userValue.follow(
                                              followingUserId: userId);
                                        },
                                      ),
                                    ),
                                  );
                                }),

                            SizedBox(
                              height: 16.h,
                            ),
                            //? story
                            SizedBox(
                                height: 83.h,
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 11.w,
                                  ),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 18.w,
                                  ),
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => StoryWidget(
                                    imageUrl: AppConstants.defaulImage,
                                    onPressed: () {},
                                    title: 'Sport',
                                    isaddWidget: index == 0,
                                  ),
                                )),

                            //? tab bar
                            Material(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              child: PreferredSize(
                                preferredSize: Size.fromHeight(44.h),
                                child: TabBar(
                                    indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                      width: 1.h,
                                      color: Theme.of(context).focusColor,
                                    )),
                                    tabs: [
                                      Tab(
                                        child: Icon(
                                          Icons.grid_on_rounded,
                                          color: Theme.of(context).focusColor,
                                        ),
                                      ),
                                      Tab(
                                        child: Icon(
                                          Icons.perm_contact_cal_rounded,
                                          color: Theme.of(context).focusColor,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
            body: TabBarView(
              children: [
                //? posts
                StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                  stream: Firesrc.firebaseFirestore
                      .collection('posts')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('you have an error'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    log(snapshot.data.toString());
                    final list = snapshot.data!.docs
                        .map((e) => PostModel.fromDocumentSnapshot(e))
                        .where((element) =>
                            element.userId == mainValue.selectedUser!.uid)
                        .toList();
                    log(list.length.toString());
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: .0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.w,
                          mainAxisSpacing: 1.h,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          PostModel? post = list[index];
                          return CupertinoContextMenu(
                            actions: [
                              CupertinoContextMenuAction(
                                child: Text(
                                  post.username ?? "post",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            previewBuilder: (context, animation, child) =>
                                FadeTransition(
                              opacity: animation,
                              child: Card(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                        color: Colors.transparent,
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.w)),
                                        child: ListTile(
                                          dense: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.w)),
                                          tileColor:
                                              Theme.of(context).backgroundColor,
                                          leading: Container(
                                              padding: EdgeInsets.all(3.w),
                                              height: 50.w,
                                              width: 50.w,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.w),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      post.userAvatar ?? '',
                                                  placeholder: (context, url) =>
                                                      const SizedBox.shrink(),
                                                  width: 25.w,
                                                  height: 25.w,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const SizedBox.shrink(),
                                                ),
                                              )),
                                          title: RichText(
                                            text: TextSpan(
                                              text: post.username ?? 'user',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        )),
                                    Flexible(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            child: child)),
                                  ],
                                ),
                              ),
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: CachedNetworkImage(
                                imageUrl: post.imageUrl ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const SizedBox.shrink(),
                                placeholder: (context, url) =>
                                    const SizedBox.shrink(),
                              ),
                            ),
                          );
                        });
                  },
                ),
                //? photos
                GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: .0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.w,
                      mainAxisSpacing: 1.h,
                    ),
                    itemCount: 0,
                    itemBuilder: (context, index) => Container(
                          color: Colors.green,
                        )),
              ],
            )),
      );
    });
  }
}