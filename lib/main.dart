import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social/Presentation/HomeScreen/home_screen.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Network/Local/cash_helper.dart';
import 'Presentation/Registration/sign_in_screen.dart';
import 'Shared/Cubit/cubit_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CashHelper.init();
  Bloc.observer = MyBlocObserver();
  // CashHelper.put(key: 'login', value: false);
  if ( CashHelper.get(key: 'login') == null) {
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
        BlocProvider(
            create: (context) => AppCubit()
              ..getUser()),
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
