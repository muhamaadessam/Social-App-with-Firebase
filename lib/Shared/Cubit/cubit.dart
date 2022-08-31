import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Chat/chat_screen.dart';
import 'package:social/Presentation/Components/Widgets/toast.dart';
import 'package:social/Presentation/Feeds/feeds_screen.dart';
import 'package:social/Presentation/Settings/settings_screen.dart';
import 'package:social/Presentation/UploadPost/upload_post.dart';
import 'package:social/Presentation/Users/users_screen.dart';
import 'package:social/Shared/Cubit/states.dart';
import 'package:social/Shared/Network/Local/cash_helper.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Presentation/Components/Constants/navigator.dart';
import '../../Presentation/HomeScreen/home_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  FToast? fToast = FToast();

  void userSignIn(
    context, {
    required String email,
    required String password,
  }) {
    emit(SignInLoadingState());
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      user.collection('users').doc(auth.currentUser!.uid).get();

      CashHelper.put(key: 'login', value: true);
      CashHelper.put(key: 'uId', value: value.user!.uid);
      navigatorReplacement(context, const HomeScreen());
      emit(SignInSuccessState());
    }).catchError((error) {
      print('Sign In Error : $error');
      String stringError = error.toString();
      var exceptionError = stringError.substring(
          stringError.split(' ')[0].length, stringError.length);
      showToast(text: exceptionError, state: ToastStates.ERROR);
      emit(SignInErrorState());
    });
  }

  var auth = FirebaseAuth.instance;
  var user = FirebaseFirestore.instance;
  UserModel? userModel;

  void userSignUp(
    context, {
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userModel = UserModel(
        email: email,
        uId: value.user!.uid,
      );

      CashHelper.put(key: 'login', value: true);
      CashHelper.put(key: 'uId', value: value.user!.uid);
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
      );
      navigatorReplacement(context, const HomeScreen());
      emit(SignUpSuccessState());
    }).catchError(
      (error) {
        String stringError = error.toString();
        var exceptionError = stringError.substring(
            stringError.split(' ')[0].length, stringError.length);
        showToast(text: exceptionError, state: ToastStates.ERROR);
        emit(SignUpErrorState());
        debugPrint('Sign UP error : $error');
      },
    );
  }

  DocumentSnapshot? snapshot;

  void getUser() async {
    emit(GetUserLoadingState());
    user.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      snapshot = value;
      Map<String, dynamic> data = snapshot!.data() as Map<String, dynamic>;
      userModel = UserModel.fromJson(data);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
      print('error for get data $error');
    });
  }

  void userCreate({
    required String? email,
    required String? name,
    required String? phone,
    required String? uId,
  }) {
    userModel = UserModel(
      name: name,
      email: email,
      uId: uId,
      phone: phone,
      bio: 'write your bio ...',
      coverImageUrl:
          'https://img.freepik.com/free-photo/view-new-york-city-night-time_53876-147490.jpg?w=900&t=st=1661938316~exp=1661938916~hmac=ff6ce4d536e6462df33fd1f1fd0da3e69a1b2aa316c92d97b35e43a2bf7f0ff7',
      imageUrl:
          'https://drive.google.com/file/d/1n1ACYKbIJRO-W6eULOd736EhyqJGD39R/view',
    );
    user.collection('users').doc(uId).set(
          userModel!.toJson(),
        );
  }

  int currentIndex = 0;
  List<String> titles = [
    'Home',
    'Chats',
    '',
    'Users',
    'Settings',
  ];
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatScreen(),
    Container(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  void changeBottomNav(context, int index) {
    if (index == 2) {
      navigatorTo(context, const CreateNewPostScreen());
      currentIndex = 0;
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNaveState());
    }
  }

  File? profileImage;
  File? coverImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      emit(GetProfileImageSuccessState());
    } else {
      emit(GetProfileImageErrorState());
      print('No image');
    }
  }

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      emit(GetProfileImageSuccessState());
    } else {
      emit(GetProfileImageErrorState());
      print('No image');
    }
  }

  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      print("profileImageUrl :$value");
      value.ref.getDownloadURL().then((value) {
        if (value != '') updateUser(imageUrl: value);
        getUser();
        print("profileImageUrl :$value");
      }).catchError((error) {
        print("profileImageUrl : error $error");
      });
    }).catchError((error) {
      print("profileImageUrl : error $error");
    });
  }

  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (value != '') updateUser(coverImageUrl: value);
        getUser();
        print('value : $value');
      }).catchError((error) {
        print('error : $error');
      });
    }).catchError((error) {
      print('error : $error');
    });
  }

  void updateUser({
    String? name,
    String? bio,
    String? phone,
    String? coverImageUrl,
    String? imageUrl,
  }) {
    emit(UpDateUserDataLoadingState());
    userModel = UserModel(
      name: name ?? userModel!.name,
      phone: phone ?? userModel!.phone,
      bio: bio ?? userModel!.bio,
      email: userModel!.email,
      uId: CashHelper.get(key: 'uId').toString(),
      coverImageUrl: coverImageUrl ?? userModel!.coverImageUrl,
      imageUrl: imageUrl ?? userModel!.imageUrl,
    );
    user
        .collection('users')
        .doc(CashHelper.get(key: 'uId'))
        .update(userModel!.toJson())
        .then((value) {
      getUser();
      emit(UpDateUserDataSuccessState());
    }).catchError((error) {
      emit(UpDateUserDataErrorState());
      print('error : $error');
    });
  }
}
