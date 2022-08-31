import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Shared/Cubit/cubit.dart';
import '../../Shared/Cubit/states.dart';
import '../Components/Constants/navigator.dart';
import '../Components/Widgets/constants.dart';
import '../Components/Widgets/svg_image.dart';
import '../Components/Widgets/text.dart';
import '../Components/Widgets/text_form_field.dart';
import 'sign_in_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var userNameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) => () {},
      builder: (context, state) => Scaffold(
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
                    sizedBox(height: 64),
                    const Center(
                      child: SvgImage(
                        image:
                            'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg',
                        network: true,
                        height: 50,
                      ),
                    ),
                    sizedBox(height: 64),
                    text(
                      'Sign Up',
                      size: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    sizedBox(height: 64),
                    CustomTextFormField(
                      onChanged: (value) {
                        debugPrint(value);
                      },
                      controller: userNameController,
                      title: 'User Name',
                      validation: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Name';
                        }
                        return null;
                      },
                    ),
                    sizedBox(height: 16),
                    CustomTextFormField(
                      onChanged: (value) {
                        debugPrint(value);
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      title: 'Phone Number',
                      validation: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null;
                      },
                    ),
                    sizedBox(height: 16),
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
                      keyboardType: TextInputType.visiblePassword,
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
                          AppCubit.get(context).userSignUp(context,
                              name: userNameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: text('Sign Up', color: Colors.white),
                        ),
                      ),
                    ),
                    sizedBox(height: 16),
                    divider(width: double.infinity),
                    sizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text('You have an account'),
                        GestureDetector(
                            onTap: () {
                              navigatorReplacement(
                                  context, const SignInScreen());
                            },
                            child: text(' Sign In', color: Colors.blue)),
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
