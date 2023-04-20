import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reminders_app/veiws/home_page.dart';
import 'package:reminders_app/veiws/sign-in.dart';
import 'package:reminders_app/widgets/colors.dart';
import 'package:reminders_app/widgets/glassmorphic_container.dart';
import 'package:reminders_app/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminders_app/auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errorMessage = '';

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      if (Auth().currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: Colors.white,
            secondRingColor: Colors.red,
            thirdRingColor: Colors.blue,
            size: 40,
          ),
        );
      },
    );
    await Auth().signInWithGoogle(context);

    // Navigator.pop(context);
    if (Auth().currentUser != null) {
      String currentUserID = Auth().currentUser!.uid;
      print(currentUserID);
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection("users");
      final DocumentReference userDocument = userCollection.doc(currentUserID);
      final DocumentSnapshot docSnapshot = await userDocument.get();
      if (!docSnapshot.exists) {
        // Create the document if it doesn't exist
        await userDocument.set({
          'email': Auth().currentUser?.email,
          'name': Auth().currentUser?.displayName
        });
      }

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/background.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                SizedBox(height: 71),
                Container(
                  width: 305,
                  height: 56,
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 3.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "S U B T L E   R E M I N D E R S",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    const GlassmorphicContainer(
                      width: 325,
                      height: 310,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20.68),
                        Text(
                          "SIGN UP",
                          style: GoogleFonts.wallpoet(
                            fontSize: 35,
                            color: lightBlue,
                            shadows: [
                              BoxShadow(
                                color: Color(0xff000000).withOpacity(0.25),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30.54),
                        GestureDetector(
                          onTap: () {
                            signInWithGoogle(context);
                          },
                          child: Container(
                            width: 271,
                            height: 50,
                            decoration: BoxDecoration(
                              color: darkBlue,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.75),
                                width: 3.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff000000).withOpacity(0.25),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Sign Up with Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Image.asset(
                                  "assets/google_logo.png",
                                  width: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 117,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color(0xffCED5D7),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff000000).withOpacity(0.25),
                                blurRadius: 4,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 31),
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              BoxShadow(
                                color: Color(0xff000000).withOpacity(0.25),
                                blurRadius: 7,
                                spreadRadius: 0,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: 132,
                            height: 44.39,
                            decoration: BoxDecoration(
                              color: darkBlue,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.75),
                                width: 3.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
