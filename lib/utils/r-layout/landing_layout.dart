// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rcore/utils/r-button/text_button.dart';

class RLandingLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState>? globalKey;
  final List<Widget>? body;
  final bool? overlayLoading;
  final String? bottomText;
  final Function()? bottomTextOnPressed;
  const RLandingLayout({
    Key? key,
    required this.globalKey,
    this.body,
    this.overlayLoading,
    this.bottomText,
    this.bottomTextOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromRGBO(255, 183, 82, 1),
          key: globalKey,
          body: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'lib/assets/images/main-logo.png',
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 20),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          width: MediaQuery.of(context).size.width - 80,
                          height: 50,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40, left: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          width: MediaQuery.of(context).size.width - 60,
                          height: 50,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 55),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            width: MediaQuery.of(context).size.width - 40,
                            padding: EdgeInsets.all(30),
                            child: Column(children: body == null ? [] : body!)),
                      ],
                    ),
                  ),
                  RTextButton(text: bottomText, onPressed: bottomTextOnPressed, color: Colors.white),
                ],
              ),
              if (overlayLoading == true)
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Opacity(
                        opacity: 0.8,
                        child: ModalBarrier(dismissible: false, color: Colors.black),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
            ],
          )),
    );
  }
}
