abstract class AppStates {}
class AppInitialState extends AppStates {}
class ChangeBottomNaveState extends AppStates {}

class SignInInitialState extends AppStates {}
class SignInLoadingState extends AppStates {}
class SignInSuccessState extends AppStates {}
class SignInErrorState extends AppStates {}

class SignUpInitialState extends AppStates {}
class SignUpLoadingState extends AppStates {}
class SignUpSuccessState extends AppStates {}
class SignUpErrorState extends AppStates {}

class NewPostState extends AppStates {}

class GetUserInitialState extends AppStates {}
class GetUserLoadingState extends AppStates {}
class GetUserSuccessState extends AppStates {}
class GetUserErrorState extends AppStates {}


class GetProfileImageSuccessState extends AppStates {}
class GetProfileImageErrorState extends AppStates {}

class GetCoverImageSuccessState extends AppStates {}
class GetCoverImageErrorState extends AppStates {}

class UploadProfileImageSuccessState extends AppStates {}
class UploadProfileImageErrorState extends AppStates {}
class UploadProfileImageLoadingState extends AppStates {}

class UploadCoverImageSuccessState extends AppStates {}
class UploadCoverImageErrorState extends AppStates {}
class UploadCoverImageLoadingState extends AppStates {}

class UpDateUserDataSuccessState extends AppStates {}
class UpDateUserDataErrorState extends AppStates {}
class UpDateUserDataLoadingState extends AppStates {}

class CreatePostSuccessState extends AppStates {}
class CreatePostErrorState extends AppStates {}
class CreatePostLoadingState extends AppStates {}

class GetPostImageSuccessState extends AppStates {}
class GetPostImageErrorState extends AppStates {}

class RemovePostImageSuccessState extends AppStates {}

class GetPostsLoadingState extends AppStates {}
class GetPostsSuccessState extends AppStates {}
class GetPostsErrorState extends AppStates {}

class SocialGetPostsSuccessState extends AppStates {}
class SocialGetPostsErrorState extends AppStates {}
class SocialGetUsersSuccessState extends AppStates {}
class SocialGetUsersErrorState extends AppStates {}
class SocialLikePostSuccessState extends AppStates {}
class SocialLikePostErrorState extends AppStates {}
class SocialCommentPostSuccessState extends AppStates {}
class SocialCommentPostErrorState extends AppStates {}

class GetCommentPostSuccessState extends AppStates {}
class GetLikePostSuccessState extends AppStates {}

class SendMessageSuccessState extends AppStates {}
class SendMessageErrorState extends AppStates {}
class GetMessageSuccessState extends AppStates {}
class GetMessageErrorState extends AppStates {}
