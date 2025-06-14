import 'dart:io';
import 'package:fitness_app/widgets.dart';
import 'package:fitness_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fitness_app/authentication.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late String email = '';
  late String password = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;
  bool googleLoading = false;
  bool appleLoading = false;
  late String? googleEmail = '';
  bool isPressed = false;

  showSpinnerEmailPassword(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  showSpinnerGoogle(bool value) {
    setState(() {
      googleLoading = value;
    });
  }

  showSpinnerApple(bool value) {
    setState(() {
      appleLoading = value;
    });
  }

  googlePressed(bool value) {
    isPressed = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    'Pump Up',
                    style: GoogleFonts.sourceSerif4(
                        color: kWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Flexible(
                child: Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome 👋 ',
                        style: kTitleTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 29),
                        child: Text(
                          'Enter your email to log in or create an\naccount.',
                          style: kButtonsTextStyle,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 34.0, bottom: 10),
                        child: Text(
                          ' Email',
                          style: TextStyle(color: kWhite, fontSize: 15),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: kWhite,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: double.infinity,
                        height: 48,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: const InputDecoration(
                            fillColor: kWhite,
                            hintText: 'Enter your email',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Text(
                          ' Password',
                          style: TextStyle(color: kWhite, fontSize: 15),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: kWhite,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: double.infinity,
                        height: 48,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: const InputDecoration(
                            fillColor: kWhite,
                            hintText: 'Password (6+ Characters)',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            showSpinnerEmailPassword(true);
                            context
                                .read<AuthenticationService>()
                                .emailPasswordSignIn(context, email, password);
                            print('spinner false');

                            showSpinnerEmailPassword(false);
                          } on Exception catch (e) {
                            Center(
                              child: Text('$e'),
                            );
                          }
                        },
                        child: isLoading
                            ? const SpinKitRing(color: kWhite)
                            : Container(
                                width: double.infinity,
                                height: 48,
                                decoration: const BoxDecoration(
                                    color: kPurple,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    'Log In / Sign Up',
                                    style:
                                        kTitleTextStyle.copyWith(fontSize: 18),
                                  ),
                                ),
                              ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 114.0, right: 114, top: 30, bottom: 10),
                        child: Center(
                          child: Text(
                            'Or, continue with',
                            style: kButtonsTextStyle,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          googleLoading
                              ? const SpinKitRing(color: kWhite)
                              : GoogleAppleButton(
                                  appLogin: 'google',
                                  color: kWhite,
                                  scale: 0.6,
                                  signInFunction: () async {
                                    showSpinnerGoogle(true); 
                                    final success = await context
                                        .read<AuthenticationService>()
                                        .signInWithGoogle(context);
                                    showSpinnerGoogle(false);

                                    if (!success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Google sign-in was cancelled or failed.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (Platform.isIOS)
                            appleLoading
                                ? const SpinKitRing(color: kWhite)
                                : GoogleAppleButton(
                                    appLogin: 'apple',
                                    color: Colors.black,
                                    scale: 0.6,
                                    signInFunction: () {
                                      showSpinnerApple(true);
                                      context
                                          .read<AuthenticationService>()
                                          .signInWithApple(context);
                                    },
                                  ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By continuing, you agree to ',
                            style: kButtonsTextStyle,
                            children: [
                              TextSpan(
                                text: 'Pump Up Terms & Conditions ',
                                style:
                                    kButtonsTextStyle.copyWith(color: kPurple),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: kButtonsTextStyle,
                              ),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style:
                                    kButtonsTextStyle.copyWith(color: kPurple),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
