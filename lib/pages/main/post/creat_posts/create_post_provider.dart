
import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_app1/models/post_model.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';
import 'package:instagram_clone_app1/service/image/image_picker_src.dart';

typedef LogautFunction = void Function(int? index);

class CreatPostProvider with ChangeNotifier{
  File? imageFile;

  final PickImage _pickImage = PickImage();

 TextEditingController? descriptionController = TextEditingController();

void restore(){
  imageFile = null;
  notifyListeners();
}

void showPostCreationType(BuildContext context){
  showDialog(
    context: context,
    barrierDismissible: true,
     builder: (context)=>CupertinoAlertDialog(
  title:  const Text('Create post'),
  content: const Text('Choose your create type'),
  actions: [
    CupertinoDialogAction(
      child: const Text('Camera'),
      onPressed: ()async {
        imageFile = await _pickImage.pickImageFromStorage(ImageSource.camera).
        then((value){
          log(value.toString());
          Navigator.of(context).pop();
          return value;
          });
          log(imageFile.toString());
          notifyListeners();
      }
    ),
    CupertinoDialogAction(
      child: const Text('Gallery'),
      onPressed: ()async{
        imageFile = await _pickImage.pickImageFromStorage(ImageSource.gallery)
        .then((value){
          log(value.toString());
          Navigator.of(context).pop();
          return value;
          
        });
         notifyListeners();
      }
    )
  ],
     ));
}

void publishPost({required LogautFunction? func})async {
  try{
  if(imageFile == null) return;
   PostModel newPost = PostModel(
    description: descriptionController!.text,
   );
   bool? isPublished = await Firesrc.uploadPost(post: newPost, imageFile: imageFile);
   if(isPublished!){
    log('Publish boldi');
    imageFile = null;
    descriptionController!.clear();
    func!(0);
   }
  }catch (e){
    log(e.toString());
  }
}

}