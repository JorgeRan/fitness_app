import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/constants.dart';
import 'package:fitness_app/routine_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/widgets.dart';
import 'package:provider/provider.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  late String routineName;
  late bool showMuscleGroup = false;
  late List finalExercisesList = [];
  late List finalDescriptionsList = [];
  late List addedExercises = [];
  bool isChecked = false;

  void updateShowMuscleGroup(bool value) {
    setState(() {
      showMuscleGroup = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(55, 120, 120, 128),
      width: double.infinity,
      child: Container(
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
                'Create Routine',
                style: kTitleTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    fillColor: Colors.white,
                    hintText: 'Routine Name',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(126, 255, 255, 255),
                    )),
                onChanged: (value) {
                  routineName = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: RoutineRadioButton(
                  onSelected: updateShowMuscleGroup,
                ),
              ),
              if (showMuscleGroup) ...[
                const Text(
                  'Select muscle groups',
                  style: TextStyle(color: kWhite, fontSize: 20),
                ),
                SizedBox(
                  height: 200,
                  child: ListView(
                    children: [
                      MuscleCheckboxListTile(
                          title: 'Upper Body',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Shoulders',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Arms',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'ForeArms',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Abs',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Adductors',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Legs',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                      MuscleCheckboxListTile(
                          title: 'Calves',
                          finalExercisesList: finalExercisesList,
                          finalDescriptionsList: finalDescriptionsList,
                          isChecked: isChecked),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final routineData =
                        Provider.of<RoutineData>(context, listen: false);

                    routineData.addRoutine(routineName);

                    User? user = FirebaseAuth.instance.currentUser;
                    if (showMuscleGroup) {
                      try {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .collection('routines')
                            .doc(routineName)
                            .set({
                          'routineName': routineName,
                          'exercises':
                              FieldValue.arrayUnion(finalExercisesList),
                          'descriptions':
                              FieldValue.arrayUnion(finalDescriptionsList),
                        });
                      } catch (e) {
                        print(e);
                      }

                      Navigator.pop(context);
                    } else {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .collection('routines')
                          .doc(routineName)
                          .set({
                        'routineName': routineName,
                        'exercises': [],
                        'descriptions': [],
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15),
                    child: Text(
                      'Create',
                      style: kButtonsTextStyle.copyWith(
                        color: const Color(0XFF36C2CE),
                      ),
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
