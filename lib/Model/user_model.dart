// import 'package:firebase_auth/firebase_auth.dart';

// final user = FirebaseAuth.instance.currentUser;

// final userData = {
//   'name': user!.displayName,
//   'email': user!.email,
// };





// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();

// exports.createIndividualTasksCollection = functions.firestore
//   .document('users/{userId}')
//   .onCreate((snap, context) => {
//     const userId = context.params.userId;
//     const individualTasksRef = admin.firestore().collection('users').doc(userId).collection('individual_tasks').doc();
//     return individualTasksRef.set({task: 'New Task', isCompleted: false});
//   });
