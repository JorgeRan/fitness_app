import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/routine_list.dart';
import 'package:fitness_app/screens/description_exercise.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/routine_exercises_screen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:fitness_app/screens/select_routine_screen.dart';
import 'package:provider/provider.dart';
import 'routine_data.dart';
import 'dart:math';

class ExerciseButton extends StatefulWidget {
  const ExerciseButton({
    required this.exerciseName,
    required this.exerciseDescription,
    required this.showAddButton,
    this.routineName,
    super.key,
  });

  final String exerciseName;
  final String exerciseDescription;
  final bool showAddButton;
  final String? routineName;

  @override
  State<ExerciseButton> createState() => _ExerciseButtonState();
}

class _ExerciseButtonState extends State<ExerciseButton> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: SizedBox(
        width: 364,
        height: 180,
        child: Card(
          elevation: elevationButtons,
          color: const Color(0XFF36C2CE),
          child: Stack(
            children: [
              if (widget.showAddButton)
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => SelectRoutine(
                              exerciseName: widget.exerciseName,
                            ));
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 110) / 2,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              'Add to routine',
                              style: kButtonsTextStyle.copyWith(
                                  color: const Color(0xFF4535C1),
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.add_circle_rounded,
                              color: Color(0xFF4535C1),
                              size: 24.22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: (MediaQuery.of(context).size.width - 66) / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'images/dumbell.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10.0, top: 30, bottom: 20),
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          FirebaseFirestore.instance
                              .collection('/users/${user!.uid}/routines/')
                              .doc(widget.routineName)
                              .update({
                            'exercises':
                                FieldValue.arrayRemove([widget.exerciseName])
                          });
                        });
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DescriptionExercise(
                                      exerciseName: widget.exerciseName,
                                      exerciseDescription:
                                          widget.exerciseDescription,
                                      showAddButton: widget.showAddButton,
                                    )));
                      },
                      child: SizedBox(
                        height: double.infinity,
                        width: (MediaQuery.of(context).size.width - 120) / 2,
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            widget.exerciseName,
                            style: kTitleTextStyle.copyWith(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BodySideButton extends StatelessWidget {
  const BodySideButton(
      {super.key, required this.sideText, required this.onTap});

  final String sideText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: elevationButtons,
        child: Container(
          width: 181,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedSide == sideText ? kCyan : kWhite,
          ),
          child: Center(
            child: Text(sideText,
                style: kButtonsTextStyle.copyWith(
                  color: selectedSide == sideText ? kWhite : kPurple,
                )),
          ),
        ),
      ),
    );
  }
}

class PopButton extends StatelessWidget {
  const PopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 10,
      child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.white,
          )),
    );
  }
}

class RoutineButton extends StatefulWidget {
  const RoutineButton({
    required this.routineName,
    super.key,
  });

  final String routineName;

  @override
  State<RoutineButton> createState() => _RoutineButtonState();
}

class _RoutineButtonState extends State<RoutineButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('routines')
            .doc(widget.routineName)
            .delete();

        Provider.of<RoutineData>(context, listen: false)
            .removeRoutine(widget.routineName);

        Provider.of<RoutineData>(context, listen: false).addFirebaseRoutines();
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    RoutineExercisesScreen(routineName: widget.routineName)));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 28.0, top: 25, bottom: 25, right: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.routineName,
                  style: kTitleTextStyle.copyWith(
                      fontWeight: FontWeight.normal, fontSize: 27),
                ),
                FutureBuilder(
                    future: Provider.of<RoutineData>(context, listen: false)
                        .countFirebaseExercises(widget.routineName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        final exerciseCount = snapshot.data;
                        return RichText(
                          text: TextSpan(
                              text: '$exerciseCount',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              children: const [
                                TextSpan(
                                  text: ' exercises',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ]),
                        );
                      }
                    })
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromARGB(69, 255, 255, 255),
          ),
        ],
      ),
    );
  }
}

class RoutineRadioButton extends StatefulWidget {
  const RoutineRadioButton({
    required this.onSelected,
    super.key,
  });
  final Function(bool) onSelected;

  @override
  State<RoutineRadioButton> createState() => _RoutineRadioButtonState();
}

class _RoutineRadioButtonState extends State<RoutineRadioButton> {
  int? _onChange = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text(
            'Custom',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          trailing: Radio(
            activeColor: Colors.white,
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              return Colors.white;
            }),
            value: 1,
            groupValue: _onChange,
            onChanged: (int? value) {
              setState(() {
                _onChange = value;
                widget.onSelected(false);
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Randomize',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          trailing: Radio(
            activeColor: Colors.white,
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              return Colors.white;
            }),
            value: 2,
            groupValue: _onChange,
            onChanged: (int? value) {
              setState(() {
                _onChange = value;
                widget.onSelected(true);
              });
            },
          ),
        ),
      ],
    );
  }
}

class MuscleCheckboxListTile extends StatefulWidget {
  MuscleCheckboxListTile({
    required this.title,
    required this.finalExercisesList,
    required this.isChecked,
    super.key,
  });

  final String title;
  final List finalExercisesList;
  late bool isChecked;

  @override
  State<MuscleCheckboxListTile> createState() => _MuscleCheckboxListTileState();
}

User? user = FirebaseAuth.instance.currentUser;

class _MuscleCheckboxListTileState extends State<MuscleCheckboxListTile> {
  bool? _checked = false;
  List addedExercises = [];

  void getMuscleExercices(String title, bool? checked, List finalExercisesList,
      List addedExercises) async {
    List exercisesList = [];

    Set<int> setOfInts = {};

    if (checked!) {
      QuerySnapshot exercisesDocs = await FirebaseFirestore.instance
          .collection('/exercises/T8fpn99FZ0tOPWvwm22t/$title')
          .get();

      for (var exercise in exercisesDocs.docs) {
        var data = exercise.data() as Map<String, dynamic>;

        exercisesList.add(data['name']);
      }

      while (setOfInts.length < 4) {
        int randomIntValue = Random().nextInt(exercisesList.length);
        setOfInts.add(randomIntValue);
        for (var i in setOfInts) {
          finalExercisesList.add(exercisesList[i]);
          addedExercises.add(exercisesList[i]);
        }
      }
    } else {
      for (var exercises in addedExercises) {
        finalExercisesList.remove(exercises);
      }
    }
  }
//hello
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        value: _checked,
        title: Text(widget.title, style: kButtonsTextStyle),
        activeColor: kWhite,
        checkColor: kCyan,
        onChanged: (value) {
          setState(() {
            _checked = value;
          });

          getMuscleExercices(
            widget.title,
            _checked,
            widget.finalExercisesList,
            addedExercises,
          );
        });
  }
}

class GoogleAppleButton extends StatelessWidget {
  GoogleAppleButton({
    required this.appLogin,
    required this.color,
    required this.scale,
    required this.signInFunction,
    super.key,
  });

  final String appLogin;
  final Color color;
  final double scale;
  late Function() signInFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: signInFunction,
      child: Container(
        width: 112,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Transform.scale(
            scale: scale,
            child: Image.asset(
              'images/$appLogin.png',
            )),
      ),
    );
  }
}