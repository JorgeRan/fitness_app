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
    routineButtonList.removeWhere((routine) => true);
    notifyListeners();
  }


  Future<void> addFirebaseRoutines() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('fetching data');
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routines')
            .get();

        final routineList = snapshot.docs;

        for (var routine in routineList) {
          final String routineName = routine.data()['routineName'];

          final routineButton = RoutineButton(routineName: routineName);
          routineButtonList.add(routineButton);
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching routines: $e');
    }
  }

  Future<int> countFirebaseExercises(String? routineName) async {
    final user = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('routines')
        .doc(routineName)
        .get();

    final exerciseList = snapshot.data()?['exercises'];

    exerciseCount = exerciseList.length;

    notifyListeners();
    return exerciseCount;
  }
}
