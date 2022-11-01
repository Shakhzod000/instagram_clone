import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/models/post_model.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/profile/profile_provider.dart';
import 'package:instagram_clone_app1/pages/profile/widget/info_widget.dart';
import 'package:instagram_clone_app1/pages/profile/widget/story_widget.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:instagram_clone_app1/utils/app_export.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider(
        create: (_) => ProfileProvider(),
        child: const ProfilePage(),
      );
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<ProfileProvider>().onChangeScroll();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileProvider, MainProvider>(
      builder: (context, profilValue, mainValue, _) {
        if (mainValue.user == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return Builder(
          builder: (context) {
            return DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  controller: profilValue.scrollController,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  headerSliverBuilder: (context, innerBoxIsscrolled) => [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      elevation: .0,
                      bottom: profilValue.showTabbar!
                          ? TabBar(
                              indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                width: 1.w,
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
                              ],
                            )
                          : PreferredSize(
                              preferredSize: Size.fromHeight(.0.h),
                              child: const SizedBox.shrink(),
                            ),
                      title: ColoredBox(
                        color: Theme.of(context).appBarTheme.backgroundColor!,
                        child: Row(
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
                              mainValue.user!.username ?? 'user',
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
                            )
                          ],
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isDismissible: true,
                                  backgroundColor: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.w)),
                                  ),
                                  builder: (context) => ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.w)),
                                        child: Material(
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  AppUtils.themeChanger();
                                                  if (Navigator.canPop(
                                                      context)) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                title: Text(
                                                  'theme',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  mainValue.logout(context);
                                                },
                                                title: Text(
                                                  'logout',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            icon: Icon(
                              Icons.menu,
                              size: 21.w,
                              color: Theme.of(context).focusColor,
                            )),
                        SizedBox(
                          width: 18.w,
                        )
                      ],
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
                                padding:
                                    EdgeInsets.only(left: 11.w, right: 28.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        borderRadius:
                                            BorderRadius.circular(43.w),
                                        child: CachedNetworkImage(
                                            imageUrl: mainValue
                                                    .user!.photoAvatarUrl ??
                                                AppConstants.defaulImage,
                                            fit: BoxFit.cover,
                                            width: 86.w,
                                            height: 86.h,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const SizedBox.shrink(),
                                            placeholder: (context, url) =>
                                                const SizedBox.shrink()),
                                      ),
                                    ),
                                    StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                      stream: Firesrc.firebaseFirestore
                                          .collection('posts')
                                          .get()
                                          .asStream(),
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
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        }
                                        final data = snapshot.data;
                                        var list = data!.docs
                                            .where((e) =>
                                                e.data()['userId'] ==
                                                AuthSrc.firebaseauth
                                                    .currentUser!.uid)
                                            .toList();
                                        log(list.length.toString());
                                        return InfoWidget(
                                            count: list.length, title: 'Posts');
                                      },
                                    ),
                                    InfoWidget(
                                        count:
                                            mainValue.user!.followers!.length,
                                        title: 'Followings'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),

                              Flexible(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 11.w, right: 28.w),
                                  child: Text(
                                    mainValue.user!.username ?? 'user',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 16.w, right: 28.w),
                                child: Text(
                                  mainValue.user!.bio ?? 'bio',
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

                              Padding(
                                padding:
                                    EdgeInsets.only(left: 11.w, right: 28.w),
                                child: SizedBox(
                                  height: 30.h,
                                  width: 343.w,
                                  child: CupertinoButton(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    color: Theme.of(context).backgroundColor,
                                    child: Text(
                                      'edit profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.h,
                              ),

                              ///Story
                              SizedBox(
                                height: 93.h,
                                child: ListView.separated(
                                  padding:
                                      EdgeInsets.only(left: 11.w, top: 9.h),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 19.w,
                                  ),
                                  itemCount: 10,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => StoryWidget(
                                    title: 'Sport',
                                    onPressed: () {},
                                    imageUrl: AppConstants.defaulImage,
                                    isaddWidget: index == 0,
                                  ),
                                ),
                              ),

                              // tab bar
                              PreferredSize(
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
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                  body: TabBarView(
                    children: [
                      //posts
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: Firesrc.firebaseFirestore
                            .collection('posts')
                            .orderBy('datePublished', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('You have an error'),
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
                                  element.userId ==
                                  AuthSrc.firebaseauth.currentUser!.uid)
                              .toList();
                          log(list.length.toString());
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: .0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      post.username ?? 'post',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
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
                                            tileColor: Theme.of(context)
                                                .backgroundColor,
                                            leading: Container(
                                              padding: EdgeInsets.all(3.w),
                                              height: 50.w,
                                              width: 50.w,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.w),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      post.userAvatar ?? '',
                                                  height: 25.w,
                                                  width: 25.w,
                                                  placeholder: (context, url) =>
                                                      const SizedBox.shrink(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const SizedBox.shrink(),
                                                ),
                                              ),
                                            ),
                                            title: RichText(
                                              text: TextSpan(
                                                  text: post.username ?? 'user',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            child: child,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  child: CachedNetworkImage(
                                    imageUrl: post.imageUrl ??
                                        AppConstants.defaulImage,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const SizedBox.shrink(),
                                    placeholder: (context, url) =>
                                        const SizedBox.shrink(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      //photos
                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: .0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.w,
                          mainAxisSpacing: 1.w,
                        ),
                        itemCount: 0,
                        itemBuilder: (context, index) => Container(
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
