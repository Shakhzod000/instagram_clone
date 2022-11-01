

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:instagram_clone_app1/models/reaction_model.dart';
import 'package:instagram_clone_app1/pages/main/main_provider.dart';
import 'package:instagram_clone_app1/pages/reaction/reaction_provider.dart';
import 'package:instagram_clone_app1/pages/reaction/widget/custom_user_card_widget.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:provider/provider.dart';

class ReactionPage extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider(
create: (_) => ReactionProvider(),
child: const ReactionPage(),
  );
  const ReactionPage({Key? key}) : super(key: key);

  @override
  State<ReactionPage> createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          title: Text(
            'Notifications',
            style: Theme.of(context)
            .textTheme.displayMedium!
            .copyWith(fontSize: 25.sp,
            fontWeight: FontWeight.w600,
            )
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: .0,
        ),
      ),
      body: Consumer2<ReactionProvider, MainProvider>(
        builder: (context, reactionValue, mainValue, _) {
          return FirestoreListView<Map<String, dynamic>>(
            query: Firesrc.firebaseFirestore
            .collection('notification')
            .doc(AuthSrc.firebaseauth.currentUser!.uid)
            .collection('reaction')
            .orderBy('reactionPublishDate', descending: true),
            shrinkWrap: true,
            itemBuilder: (context, document){
              if(!document.exists){
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if(document.data().isEmpty){
                return const  Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              final ReactionModel reactionModel = 
              ReactionModel.fromDocumentSnapshot(document);
              return CustomCardItemReaction(
                datetime: reactionModel.myUsername,
                imageUrl: reactionModel.reactionPublishDate,
                onPressed: (){},
                postImageUrl: reactionModel.imageUrl,
                text: reactionModel.reactionTex,
                 username: reactionModel.myUsername);
            },
          );
        },
      ),
    );
  }
}