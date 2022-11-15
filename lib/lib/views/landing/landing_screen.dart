// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rcore/bloc/auth/bloc_auth.dart';
import 'package:rcore/utils/r-navigator/navigator.dart';
import 'package:rcore/views/landing/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../statistical/main_statistical.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    _checkAutoLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocAuth, BlocAuthState>(
      listener: (context, state) async {
        if (state is BlocAuthLoginSuccess) {
          return newScreen(MainStatisticalScreen(user: state.user), context);
        }

        if (state is BlocAuthLoginFaild) {
          return newScreen(LoginScreen(), context);
        }
      },
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 183, 82, 1),
        ),
        child: (Center(
            child: Image.asset(
          'lib/assets/images/landing-logo.png',
          width: 300,
        ))),
      )),
    );
  }

  _checkAutoLogin(BuildContext context) async {
    Future.delayed(
      Duration(seconds: 3),
      () async {
        var prefs = await SharedPreferences.getInstance();
        String? autoLogin = prefs.getString('auto_login');

        if (autoLogin == 'true') {
          String? token = await FirebaseMessaging.instance.getToken();
          String? username = prefs.getString('username')!;
          String? password = prefs.getString('password')!;
          BlocProvider.of<BlocAuth>(context).add(
            BlocAuthLoginEvent(
              username: username,
              password: password,
              deviceToken: token!,
            ),
          );
        } else {
          newScreen(LoginScreen(), context);
        }
      },
    );
  }
}
