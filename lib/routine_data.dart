import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/widgets.dart';

class RoutineData extends ChangeNotifier {
  List<Widget> routineButtonList = [];
  int exerciseCount = 0;

  void addRoutine(String newRoutineName) {
    final routine = RoutineButton(routineName: newRoutineName);
    routineButtonList.add(routine);
    notifyListeners();
  }

  void removeRoutine(String routineName) {
    routineButtonList.remove(RoutineButton(routineName: routineName));
    notifyListeners();
  }

  Future<void> addFirebaseRoutines() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('routines')
          .get();

      final routineList = snapshot.docs;

      for (var routine in routineList) {
        final String routineName = routine.data()['routineName'];

        final routineButton = RoutineButton(routineName: routineName);
        routineButtonList.add(routineButton);
      }
      notifyListeners();
    } catch (e) {
      //ignore
    }
  }

  Stream<int> countFirebaseExercises(String? routineName) {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('routines')
        .doc(routineName)
        .snapshots()
        .map((snapshot) {
      final exerciseList = snapshot.data()?['exercises'] ?? [];

      return exerciseList.length;
    });
  }
}
