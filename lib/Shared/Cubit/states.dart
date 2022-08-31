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