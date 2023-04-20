import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reminders_app/auth.dart';
import 'package:reminders_app/veiws/sign-up.dart';
import 'package:reminders_app/widgets/colors.dart';
import 'package:reminders_app/widgets/glassmorphic_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> signOut() async {
    await Auth().signOut().then((value) => Navigator.of(context).pop());
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controllerTask = TextEditingController();
    String currentUserID = Auth().currentUser!.uid;
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .collection("individual_tasks")
        .orderBy("timestamp", descending: true)
        .snapshots() as Stream<QuerySnapshot<Object?>>;
    return ScreenUtilInit(
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: double.maxFinite,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 152.w),
                      StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return snapshot.hasData &&
                                  snapshot.data!.docs.length > 0
                              ? SizedBox(
                                  height: MediaQuery.of(context).size.height -
                                      192.029.w,
                                  child: ListView.builder(
                                    reverse: false,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> document =
                                          snapshot.data!.docs[index].data()
                                              as Map<String, dynamic>;
                                      return Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  14.w, 0, 14.w, 18.w),
                                              child: Slidable(
                                                endActionPane: ActionPane(
                                                    motion:
                                                        const StretchMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        spacing: 0,
                                                        onPressed: (context) {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(
                                                                  currentUserID)
                                                              .collection(
                                                                  "individual_tasks")
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id)
                                                              .delete();
                                                        },
                                                        icon: Icons.delete,
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                232,
                                                                36,
                                                                36),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.w),
                                                      ),
                                                    ]),
                                                child: Container(
                                                  height: 59.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.75),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.w),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.25),
                                                        offset:
                                                            const Offset(0, 4),
                                                        blurRadius: 4,
                                                        spreadRadius: 0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value: document[
                                                            "isCompleted"],
                                                        activeColor: darkBlue,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            if (document[
                                                                    "isCompleted"] ==
                                                                false) {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(
                                                                      currentUserID)
                                                                  .collection(
                                                                      "individual_tasks")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "isCompleted":
                                                                    true
                                                              });
                                                            } else {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "users")
                                                                  .doc(
                                                                      currentUserID)
                                                                  .collection(
                                                                      "individual_tasks")
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                "isCompleted":
                                                                    false
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10.w,
                                                                16.w,
                                                                0,
                                                                16.w),
                                                        child: Text(
                                                          document["task"],
                                                          style: TextStyle(
                                                            color: darkBlue,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            decoration: document[
                                                                        "isCompleted"] ==
                                                                    true
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 133.w),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        // SizedBox(height: 133.w),
                                        Container(
                                          width: 284.w,
                                          height: 42.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xffDDDDDD)
                                                .withOpacity(0.81),
                                            borderRadius:
                                                BorderRadius.circular(40.w),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  offset: Offset(0, 4),
                                                  blurRadius: 4,
                                                  spreadRadius: 0),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "You don't have any tasks yet!",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.w),
                                        Container(
                                          width: 313.w,
                                          height: 42.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xffDDDDDD)
                                                .withOpacity(0.81),
                                            borderRadius:
                                                BorderRadius.circular(40.w),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  offset: Offset(0, 4),
                                                  blurRadius: 4,
                                                  spreadRadius: 0),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Press on (+) to add new tasks",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                      // SizedBox(height: 60.w),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 385.w,
                              height: 64.w,
                              decoration: BoxDecoration(
                                color: darkBlue,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                ),
                                border: Border.all(
                                    color: Colors.white, width: 1.5.w),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(5, 6),
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        19.w, 19.w, 0, 19.w),
                                    child: Text(
                                      "Hello, ${Auth().currentUser?.displayName}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 7.w, 7.w, 7.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SizedBox(
                                            width: 380.w,
                                            height: 204.w,
                                            child: AlertDialog(
                                              backgroundColor:
                                                  darkBlue.withOpacity(0.75),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(35.w),
                                                side: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2),
                                              ),
                                              title: const Text(
                                                "Do you want to sign-out?",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              actions: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10.w, 0, 10.w, 10.w),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          width: 123.w,
                                                          height: 41.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff00263F),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.w),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "CANCEL",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          try {
                                                            signOut()
                                                                .then(
                                                                  (value) =>
                                                                      Navigator
                                                                          .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SignUpPage(),
                                                                    ),
                                                                  ),
                                                                )
                                                                .then((value) =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop());
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 123.w,
                                                          height: 41.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xff00263F),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.w),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "SIGN-OUT",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          shape: BoxShape.circle,
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 7,
                                              spreadRadius: 2,
                                              offset: Offset(0, 0),
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.exit_to_app_outlined,
                                          color: Colors.white,
                                          size: 30.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 385.w,
                              height: 64.w,
                              decoration: BoxDecoration(
                                color: darkBlue,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(100),
                                ),
                                border: Border.all(
                                    color: Colors.white, width: 1.5.w),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(5, 6),
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(6.w, 6.w, 0, 6.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SizedBox(
                                            width: 380.w,
                                            height: 204.w,
                                            child: Form(
                                              key: _formKey,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    darkBlue.withOpacity(0.75),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.w),
                                                  side: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2),
                                                ),
                                                title: const Text(
                                                  "Task Name",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter some Text";
                                                    }
                                                  },
                                                  autofocus: true,
                                                  // focusNode: _focusNode,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller: _controllerTask,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter your Task...",
                                                    hintStyle: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                    ),
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10.w,
                                                            0,
                                                            10.w,
                                                            10.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            width: 123.w,
                                                            height: 41.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xff00263F),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.w),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                "CANCEL",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final isTaskValid =
                                                                _formKey
                                                                    .currentState!
                                                                    .validate();
                                                            if (isTaskValid) {
                                                              try {
                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Center(
                                                                        child: LoadingAnimationWidget.discreteCircle(
                                                                            color:
                                                                                Colors.white,
                                                                            secondRingColor: Colors.red,
                                                                            thirdRingColor: Colors.blue,
                                                                            size: 40),
                                                                      );
                                                                    });
                                                                Navigator.pop(
                                                                    context);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .doc(
                                                                        currentUserID)
                                                                    .collection(
                                                                        "individual_tasks")
                                                                    .add(
                                                                  {
                                                                    "task":
                                                                        _controllerTask
                                                                            .text,
                                                                    "isCompleted":
                                                                        false,
                                                                    "timestamp":
                                                                        FieldValue
                                                                            .serverTimestamp(),
                                                                  },
                                                                );
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 123.w,
                                                            height: 41.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xff00263F),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.w),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                "ADD",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                        _controllerTask.clear();
                                      },
                                      child: Container(
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          color: darkBlue,
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            const BoxShadow(
                                                blurRadius: 7,
                                                spreadRadius: 2,
                                                offset: Offset(0, 0),
                                                color: Colors.white)
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 34.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 88.w),
                                  const Text(
                                    "My Tasks",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // designSize: Size(428, 926),
      designSize: const Size(393, 852),
    );
  }
}

// Text(Auth().currentUser?.displayName ?? "No Name")
