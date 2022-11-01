
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_clone_app1/pages/story/story_view_provider.dart';
import 'package:provider/provider.dart';

class StoryView extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider(
    create: (_) => StoryViewProvider(),
    child: const StoryView(),
  );

  const StoryView({Key? key}) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryViewProvider>(
      builder: (context, storyValue, _){
        return Scaffold(
         
        );
      });
  }

}
