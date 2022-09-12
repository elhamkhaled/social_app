import 'dart:io';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/modules/chats/chats_screen.dart';
import 'package:chat_application/modules/feeds/feeds_screen.dart';
import 'package:chat_application/modules/new_posts/new_posts_screen.dart';
import 'package:chat_application/modules/settings/settings_screen.dart';
import 'package:chat_application/modules/users/users_screen.dart';
import 'package:chat_application/shared/components/constants.dart';
import 'package:chat_application/social_cubit/social_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/components/components.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);

      print(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
      print(error.toString());
    });
  }

  int currentIndex = 0;

  List<Widget> screen = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> title = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index) {
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  final ImagePicker picker = ImagePicker();

  XFile? profileImage;
  File? profileImageFile;

  Future<void> getProfileImage() async {
    profileImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (profileImage != null) {
      profileImageFile = File(profileImage!.path);

      emit(SocialProfileImagePickedSuccessState());
    } else {
      showToast(text: 'No image selected', state: ToastStates.WARNING);
      emit(SocialProfileImagePickedErrorState());
    }
  }

  XFile? coverImage;
  File? coverImageFile;

  Future<void> getcoverImage() async {
    coverImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (coverImage != null) {
      coverImageFile = File(coverImage!.path);

      emit(SocialCoverImagePickedSuccessState());
    } else {
      showToast(text: 'No image selected', state: ToastStates.WARNING);
      emit(SocialCoverImagePickedErrorState());
    }
  }

  String profileImageUrl = '';
  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserUpdateLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
        // emit(SocialUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
      print(error.toString());
    });
  }

  String coverImageUrl = '';
  void uploadCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) async {
    emit(SocialUserUpdateLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        coverImageUrl = value;
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        //  emit(SocialUploadCoverImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
      print(error.toString());
    });
  }

  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel socialUserModel = SocialUserModel(
      uId: uId,
      email: userModel!.email ?? 'your mail',
      image: image ??
          userModel!.image ??
          'https://img.freepik.com/premium-photo/3d-rendering-3d-illustration-people-avatar-icon-isolated-white-background_640106-552.jpg?size=626&ext=jpg&uid=R78364619&ga=GA1.2.140343669.1662316312',
      cover: cover ??
          userModel!.cover ??
          'https://img.freepik.com/free-photo/abstract-luxury-gradient-blue-background-smooth-dark-blue-with-black-vignette-studio-banner_1258-82801.jpg?size=626&ext=jpg&uid=R78364619&ga=GA1.2.140343669.1662316312',
      name: name ?? 'Name',
      phone: phone ?? 'Number Phone',
      bio: bio ?? 'your bio',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(socialUserModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(SocialUserUpdateErrorState());
    });
  }
}
