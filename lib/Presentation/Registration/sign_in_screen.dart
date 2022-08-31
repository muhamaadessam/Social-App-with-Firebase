import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/Presentation/Registration/registration_screen.dart';
import 'package:social/Shared/Cubit/cubit.dart';
import 'package:social/Shared/Cubit/states.dart';
import '../Components/Constants/navigator.dart';
import '../Components/Widgets/constants.dart';
import '../Components/Widgets/svg_image.dart';
import '../Components/Widgets/text.dart';
import '../Components/Widgets/text_form_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {
        if(state is SignInErrorState){
          Fluttertoast.showToast(
              msg: "This is Center Short Toast",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 60,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      },
      builder: (context, state) =>
          Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        sizedBox(height: 96),
                        const Center(
                          child: SvgImage(
                            image:
                            'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
                            network: true,
                            height: 50,
                          ),
                        ),
                        sizedBox(height: 80),
                        text(
                          'Sign In',
                          size: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        sizedBox(height: 64),
                        CustomTextFormField(
                          onChanged: (value) {
                            debugPrint(value);
                          },
                          controller: emailController,
                          title: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validation: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Email';
                            }
                            return null;
                          },
                        ),
                        sizedBox(height: 16),
                        CustomTextFormField(
                          onChanged: (value) {
                            debugPrint(value);
                          },
                          controller: passwordController,
                          isPassword: true,
                          title: 'Password',
                          validation: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        sizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AppCubit.get(context).userSignIn(
                                  context, email: emailController.text,
                                  password: passwordController.text);

                            }
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: text('Sign In', color: Colors.white),
                            ),
                          ),
                        ),
                        sizedBox(height: 16),
                        divider(width: double.infinity),
                        sizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            text('You don\'t have account'),
                            GestureDetector(
                                onTap: () {
                                  navigatorReplacement(
                                      context, const RegistrationScreen());
                                },
                                child:
                                text(' Create Account', color: Colors.blue)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
