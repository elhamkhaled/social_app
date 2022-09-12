import 'package:chat_application/layout/home_screen.dart';
import 'package:chat_application/modules/login_screen/login_screen.dart';
import 'package:chat_application/modules/register_screen/cubit/register_cubit.dart';
import 'package:chat_application/modules/register_screen/cubit/register_states.dart';
import 'package:chat_application/shared/components/components.dart';
import 'package:chat_application/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  Color bacmesg = Colors.white;
  String mesg = '';
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            navigateAndFinish(
              context,
              SocialLayout(),
            );
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
                          'REGISTER',
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
                          'REGISTER NOW TO COMMUNICATE WITH FRIENDS',
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
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
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
                          prefix: Icons.email,
                          label: 'Email Address',
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFiled(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword:
                              SocialRegisterCubit.get(context).isPassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormFiled(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          label: 'phone',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLodingState,
                          builder: (context) => defaultButton(
                            background: defaultColor,
                            btnfunction: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'register',
                          ),
                          fallback: (context) => CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 7.0),
                          decoration: BoxDecoration(
                              color: bacmesg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          alignment: Alignment.center,
                          child: Text(
                            mesg,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
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
