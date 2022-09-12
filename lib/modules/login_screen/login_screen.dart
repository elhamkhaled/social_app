import 'package:chat_application/layout/home_screen.dart';
import 'package:chat_application/modules/login_screen/cubit/login_cubit.dart';
import 'package:chat_application/modules/login_screen/cubit/login_states.dart';
import 'package:chat_application/modules/register_screen/register_screen.dart';
import 'package:chat_application/shared/components/components.dart';
import 'package:chat_application/shared/network/local/cach_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/colors.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwrodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            print(state.error.toString());
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessState) {
            CachHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.facebook,
                          color: defaultColor,
                          size: 100.0,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'LOGIN NOW TO COMMUNICATE WITH FRIENDS',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormFiled(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFiled(
                          controller: passwrodController,
                          type: TextInputType.visiblePassword,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              /* SocialLoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passwrodController.text,
                            );*/
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: SocialLoginCubit.get(context).suffix,
                          suffixPressed: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLodingState,
                          builder: (context) => defaultButton(
                            background: defaultColor,
                            btnfunction: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwrodController.text,
                                );
                              }
                            },
                            text: 'LOGIN',
                          ),
                          fallback: (context) => CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have account?'),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, SocialRegisterScreen());
                                },
                                child: Text('register'.toUpperCase()))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
