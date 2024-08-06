import 'dart:ffi';

import 'package:fitness_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectRoutine extends StatefulWidget {
  const SelectRoutine({required this.exerciseName, required this.description, super.key});

  final String exerciseName;
  final String description;

  @override
  State<SelectRoutine> createState() => _SelectRoutineState();
}

class _SelectRoutineState extends State<SelectRoutine> {
  String? selectedRoutine = '';
  final user = FirebaseAuth.instance.currentUser;
  List exerciseRoutineList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(55, 120, 120, 128),
      width: double.infinity,
      child: Container(
        height: 360,
        decoration: const BoxDecoration(
          color: Color(0XFF36C2CE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 33),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'Select Routine',
                style: kTitleTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/users/${user?.uid}/routines')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final routineList = snapshot.data!.docs;

                    List<DropdownMenuItem<String>> dropdownRoutines = [];

                    for (var routine in routineList) {
                      final routineData =
                          routine.data() as Map<String, dynamic>?;
                      final routineName = routineData?['routineName'];

                      var newItem = DropdownMenuItem<String>(
                        value: routineName,
                        child: Text(routineName),
                      );
                      dropdownRoutines.add(newItem);
                    }

                    return DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: kCyan,
                      alignment: Alignment.center,
                      style: kButtonsTextStyle.copyWith(fontSize: 20),
                      value:
                          selectedRoutine!.isNotEmpty ? selectedRoutine : null,
                      hint: const Text(
                        "Select a routine",
                        style: TextStyle(color: kWhite, fontSize: 20),
                      ),
                      items: dropdownRoutines,
                      onChanged: (value) {
                        setState(() {
                          selectedRoutine = value;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  User? user = FirebaseAuth.instance.currentUser;

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('routines')
                      .doc(selectedRoutine)
                      .set({
                    'routineName': selectedRoutine,
                    'exercises': FieldValue.arrayUnion([widget.exerciseName]),
                    'descriptions': FieldValue.arrayUnion([widget.description])
                  }, SetOptions(merge: true));

                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15),
                  child: Text(
                    'Add',
                    style: kButtonsTextStyle.copyWith(
                      color: const Color(0XFF36C2CE),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
