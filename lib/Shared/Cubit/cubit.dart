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
import 'package:social/Presentation/Settings/profile_screen.dart';
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
    'Notifications',
    'Profile',
  ];
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatScreen(),
    Container(),
    const UsersScreen(),
    const ProfileScreen(),
  ];
  File? coverImage;
  var picker = ImagePicker();
  File? profileImage;
  File? postImage;
  String? postImageUrlPut;
  PostModel? postModel;
  List<PostModel> posts = [];
  List<PostModel> myPosts = [];
  List<UserModel> users = [];
  List<String> postsId = [];
  List<String> myPostsId = [];

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
          'https://img.freepik.com/free-vector/ornament-beautiful-background-geometric-circle-element_1159-20358.jpg?w=900&t=st=1662150415~exp=1662151015~hmac=2f0f54f84eeb7df70128663886b5e31f37e3126e7c68a41f767b0c5043340fb1',
      imageUrl:
          'https://img.freepik.com/free-vector/man-shows-gesture-great-idea_10045-637.jpg?w=740&t=st=1662151566~exp=1662152166~hmac=36fe98bddbcc8fe5e83010a33b79a277e5217c66a16b16fa4b88fcb6d3babb39',
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

  void removePostImageUrl() {
    postImageUrlPut = null;
    emit(RemoveImagePostFromUrlSuccessState());
  }

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      //uploadPostImage();
      emit(GetPostImageSuccessState());
    } else {
      emit(GetPostImageErrorState());
    }
  }

  void getPostImageUrlPut(String image) {
    postImageUrlPut = image;
    emit(GetImagePostFromUrlSuccessState());
  }

  void createPost({String? dateTime, String? text, String? postImageUrl}) {
    emit(CreatePostLoadingState());
    postModel = PostModel(
      name: userModel!.name,
      imageUrl: userModel!.imageUrl,
      uId: CashHelper.get(key: 'uId'),
      dateTime: dateTime ?? '',
      text: text ?? '',
      postImageUrl: postImageUrl ?? postImageUrlPut ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel!.toJson())
        .then((value) {
      getPosts(uId: CashHelper.get(key: 'uId'));
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void updatePost(
      {String? updateDateTime,
      String? text,
      String? postImageUrl,
      String? postId}) {
    emit(UpDatePostLoadingState());
    postModel = PostModel(
      name: userModel!.name,
      imageUrl: userModel!.imageUrl,
      uId: CashHelper.get(key: 'uId'),
      updateDateTime: updateDateTime ?? '',
      text: text ?? '',
      postImageUrl: postImageUrl ?? postImageUrlPut ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(postModel!.toJson())
        .then((value) {
      emit(UpDatePostSuccessState());
    }).catchError((error) {
      emit(UpDatePostErrorState());
    });
  }

  void uploadPostImage({String? dateTime, String? text, bool? update}) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (update!) {
          updatePost(
            updateDateTime: dateTime,
            text: text,
            postImageUrl: value,
          );
        } else {
          createPost(
            dateTime: dateTime,
            text: text,
            postImageUrl: value,
          );
        }
        emit(CreatePostSuccessState());
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  PostModel? postModelWithId;

  void getPostDataWithId(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      postModelWithId = PostModel.fromJson(value.data()!);
    });
  }

  void getPosts({String? uId}) async {
    emit(SocialGetPostsLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      postsId.clear();
      posts.clear();
      myPostsId.clear();
      myPosts.clear();
      for (var element in value.docs) {
        if (uId == CashHelper.get(key: 'uId')) {
          myPostsId.add(element.id);
          myPosts.add(PostModel.fromJson(element.data()));
        }
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(SocialGetPostsSuccessState());
    });
  }

  void deletePosts({String? postId}) async {
    FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    getPosts();
    emit(SocialDeletePostsState());
  }

  Stream<DocumentSnapshot<Object?>>? getLikeStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(CashHelper.get(key: 'uId'))
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>>? getNumberLikeStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>>? getCommentsLikeStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots();
  }

  void addLike({bool? liked, String? postId}) {
    liked = !liked!;
    if (liked) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(CashHelper.get(key: 'uId'))
          .set({'like': true, 'uId': CashHelper.get(key: 'uId')});
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(CashHelper.get(key: 'uId'))
          .delete();
    }
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
