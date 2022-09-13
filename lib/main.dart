import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social/Presentation/HomeScreen/home_screen.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Network/Local/cash_helper.dart';
import 'Presentation/Components/Widgets/toast.dart';
import 'Presentation/Registration/sign_in_screen.dart';
import 'Shared/Cubit/cubit_observer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  print('on background message');
  print(message!.data.toString());

  showToast(
    text: 'on background message',
    state: ToastStates.SUCCESS,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();

  // var token = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());

    showToast(
      text: 'on message',
      state: ToastStates.SUCCESS,
    );
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(
      text: 'on message opened app',
      state: ToastStates.SUCCESS,
    );
  });

  Bloc.observer = MyBlocObserver();
  // CashHelper.put(key: 'login', value: false);
  if (CashHelper.get(key: 'login') == null) {
    CashHelper.put(key: 'login', value: false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()..getUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: CashHelper.get(key: 'login')
            ? const HomeScreen()
            : const SignInScreen(),
      ),
    );
  }
}
