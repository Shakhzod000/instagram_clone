import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfire_ui/auth.dart';
import 'dart:io';
import 'dart:developer';

import 'package:instagram_clone_app1/models/user_model.dart';

class AuthSrc{
  static final _firebaseAuth = FirebaseAuth.instance;
  static final _firebasestorage = FirebaseStorage.instance;
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static FirebaseAuth get firebaseauth => _firebaseAuth;

  /// Sign In
 static Future<UserCredential?> signIn(
  {required String? username, required String? password})async {
  try{  final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: username!, password: password!);
    return userCredential;
  } on FirebaseException catch (e){
    log(e.toString());
  }
 return null;
  } 

 
  /// Sign Up
   static Future<bool?> signUp({
    required String? username,
    required String? email,
    required String? password,
    required String? bio,
    required File? imageFile,
   }) async {
    try{
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email!, password: password!);
     UserModel? user = UserModel(
      username: username,
      email: email,
      uid: userCredential.user!.uid,
      followers: [],
      following: [],
      bio: bio,
      photoAvatarUrl:
      await uploadFileToStorage(fileName: username!, file: imageFile)
     );
     if(user.photoAvatarUrl == null) return null;
     await _firebaseFireStore
     .collection('user')
     .doc(userCredential.user!.uid)
     .set(user.toJson());
     if(kDebugMode){
      print(
        "Siz muvoffaqiyatli ro'yhattan o'ttingiz"
      );
     }
     return null;
    }on FirebaseException catch(e){
      if(kDebugMode){
        print(e);
      }
      log(e.toString());
    }
     
   }



 static Future<String?> uploadFileToStorage({
  required String fileName, required File? file
 }) async{
  try{
    var ref = _firebasestorage.ref();
    var newRef = ref.child('avatarPhoto').child(fileName);
    UploadTask? task = newRef.putFile(file!);
    await task;
    return newRef.getDownloadURL();
  }catch (e){
    log(e.toString());
  }
  return null;
 }


static Future<UserModel?> get getCurrentuser async{
  try{
    final uid = _firebaseAuth.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = 
    await _firebaseFireStore.collection('user').doc(uid).get();
    final UserModel userModel = UserModel.fromDocumentSnapshot(documentSnapshot);
    return userModel;
  }catch (e){
    log(e.toString());
  }
  return null;
} 

static Future<UserModel?> getSelectedUser({required String? userUid})async{
  try{
  final uid =userUid;
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = 
  await _firebaseFireStore.collection('user').doc(uid).get();
  final UserModel userModel = 
  UserModel.fromDocumentSnapshot(documentSnapshot);
  return userModel;
  }catch(e){
    log(e.toString());
  }
  return null;
}
 

static Future<bool?> updateUser({
  required File? imageFile,
  required String? username,
  required UserModel? updateUser,
})async{
  try{
    UserModel? newUser = updateUser!.copyWith(
      photoAvatarUrl: 
      await uploadFileToStorage(fileName: username!, file: imageFile)
    );
    if(newUser.photoAvatarUrl == null) return null;
    await _firebaseFireStore
    .collection('users')
    .doc(updateUser.uid)
    .update(newUser.toJson());
    if(kDebugMode){
      print('siz muvoffaqiyatli profilni yangiladingiz');
    }
   
  }on FirebaseException catch(e){
    if(kDebugMode){
      print(e);
    }
    log(e.toString());
  }
  return null;
}

  
}