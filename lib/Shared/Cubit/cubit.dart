import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/Models/message_model.dart';
import 'package:social/Models/post_model.dart';
import 'package:social/Models/user_model.dart';
import 'package:social/Presentation/Chat/chat_screen.dart';
import 'package:social/Presentation/Components/Widgets/toast.dart';
import 'package:social/Presentation/Feeds/feeds_screen.dart';
import 'package:social/Presentation/Settings/settings_screen.dart';
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
  var auth = FirebaseAuth.instance;
  UserModel? userModel;
  DocumentSnapshot? snapshot;
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
  File? coverImage;
  var picker = ImagePicker();
  File? profileImage;
  File? postImage;
  PostModel? postModel;
  List<PostModel> posts = [];
  List<UserModel> users = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> comments = [];

  void userSignIn(context, {required String email, required String password}) {
    emit(SignInLoadingState());
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

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

  void userSignUp(context,
      {required String name,
      required String phone,
      required String email,
      required String password}) {
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

  void getUser() async {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      snapshot = value;
      Map<String, dynamic> data = snapshot!.data() as Map<String, dynamic>;
      userModel = UserModel.fromJson(data);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
      print('error for get data $error');
    });
  }

  void userCreate(
      {required String? email,
      required String? name,
      required String? phone,
      required String? uId}) {
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
    FirebaseFirestore.instance.collection('users').doc(uId).set(
          userModel!.toJson(),
        );
  }

  void changeBottomNav(context, int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(NewPostState());
    } else {
      print('deletsed');
      currentIndex = index;
      emit(ChangeBottomNaveState());
    }
  }

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

  void uploadProfileImage() async {
    await firebase_storage.FirebaseStorage.instance
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

  void updateUser(
      {String? name,
      String? bio,
      String? phone,
      String? coverImageUrl,
      String? imageUrl}) {
    emit(UpDateUserDataLoadingState());
    userModel = UserModel(
      name: name ?? userModel!.name,
      phone: phone ?? userModel!.phone,
      bio: bio ?? userModel!.bio,
      email: userModel!.email,
      uId: CashHelper.get(key: 'uId'),
      coverImageUrl: coverImageUrl ?? userModel!.coverImageUrl,
      imageUrl: imageUrl ?? userModel!.imageUrl,
    );
    FirebaseFirestore.instance
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

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageSuccessState());
  }

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      //uploadPostImage();
      emit(GetPostImageSuccessState());
    } else {
      emit(GetPostImageErrorState());
      print('No image');
    }
  }

  void createPost({String? dateTime, String? text, String? postImageUrl}) {
    print("PATH: Create Post");
    emit(CreatePostLoadingState());
    postModel = PostModel(
      name: userModel!.name,
      imageUrl: userModel!.imageUrl,
      uId: CashHelper.get(key: 'uId'),
      dateTime: dateTime ?? '',
      text: text ?? '',
      postImageUrl: postImageUrl ?? '',
    );
    print("PATH: Create Post before modelling");
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toJson())
        .then((value) {
      print("PATH: Create Post after add data");
      getPosts();
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
      print('error : $error');
    });
  }

  void uploadPostImage({String? dateTime, String? text}) {
    emit(CreatePostLoadingState());
    print("PATH: upload Post Image");
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImageUrl: value,
        );
        print("PATH: upload Post Image after create Post");
        emit(CreatePostSuccessState());
      }).catchError((error) {
        emit(CreatePostErrorState());

        print('error : $error');
      });
    }).catchError((error) {
      emit(CreatePostErrorState());

      print('error : $error');
    });
  }

  void getPosts() async {
    postsId.clear();
    posts.clear();
    likes.clear();
    comments.clear();

    // print(" commentss ${comments.length}");
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          emit(GetLikePostSuccessState());
        }).catchError((error) {});

        element.reference.collection('comments').get().then((value) {
          comments.add(value.docs.length);
          emit(GetCommentPostSuccessState());
        }).catchError((error) {
          print("error in comments $error");
        });
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      print("comments in cubit ${comments.length}");

      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(CashHelper.get(key: 'uId'))
        .set({'like': true, 'uId': CashHelper.get(key: 'uId')}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState());
    });
  }

  void commentPost({String? postId, String? comment}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set({'comment': comment, 'uId': CashHelper.get(key: 'uId')}).then(
            (value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState());
    });
  }

  void getUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetUsersErrorState());
      });
    }
  }

  void sendMessage({
    String? receiverId,
    String? dateTime,
    String? message,
  }) {
    MessageModel model = MessageModel(
        message: message,
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({String? receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      event.docs.reversed.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }
}
