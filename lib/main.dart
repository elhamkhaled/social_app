// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:chat_application/layout/home_screen.dart';
import 'package:chat_application/modules/login_screen/login_screen.dart';
import 'package:chat_application/shared/components/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/bloc_observe.dart';
import 'shared/cubit/app_cubit.dart';
import 'shared/cubit/app_states.dart';
import 'social_cubit/social_cubit.dart';
import 'shared/network/local/cach_helper.dart';
import 'shared/styles/thems.dart';

void main() async {
  WidgetsFlutterBinding();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
    () async {
      await CachHelper.init();

      bool isDark = CachHelper.getData(key: 'isDark') ?? false;

      Widget widget;
      uId = CachHelper.getData(key: 'uId');
      if (uId != null) {
        widget = SocialLayout();
      } else {
        widget = SocialLoginScreen();
      }

      runApp(MyApp(
        isDark: isDark,
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

//calss MyApp
class MyApp extends StatelessWidget {
  bool? isDark;
  late Widget startWidget;

  MyApp({required this.isDark, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark!,
              ),
          ),
          BlocProvider(
            create: (BuildContext context) => SocialCubit()..getUserData(),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightThem,
              darkTheme: darkThem,
              themeMode: AppCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: startWidget,
            );
          },
        ));
  }
}
