import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/create_routine.dart';
import 'package:fitness_app/screens/description_exercise.dart';
import 'package:fitness_app/screens/home_screen.dart';
import 'package:fitness_app/screens/routine_exercises_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    this.selectedPart,
    super.key,
  });

  final String exerciseName;
  final String exerciseDescription;
  final bool showAddButton;
  final String? routineName;
  final String? selectedPart;

  @override
  State<ExerciseButton> createState() => _ExerciseButtonState();
}

class _ExerciseButtonState extends State<ExerciseButton> {
  User? user = FirebaseAuth.instance.currentUser;

  void _removeMuscleGroupToRoutine(
      String muscleGroup, String exercise, String description) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var routineRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('routines')
          .doc(widget.routineName);

      DocumentSnapshot docSnapshot = await routineRef.get();

      List<dynamic> currentSelectedParts = docSnapshot['selectedParts'] ?? [];

      currentSelectedParts.remove(muscleGroup);

      await routineRef.update({
        'descriptions': FieldValue.arrayRemove([description]),
        'exercises': FieldValue.arrayRemove([exercise]),
        'selectedParts': currentSelectedParts,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: SizedBox(
        width: 364,
        height: 166,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DescriptionExercise(
                          exerciseName: widget.exerciseName,
                          exerciseDescription: widget.exerciseDescription,
                          showAddButton: widget.showAddButton,
                          selectedPart: widget.selectedPart,
                        )));
          },
          child: Card(
            elevation: elevationButtons,
            color: const Color(0XFF36C2CE),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 67) / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref(
                              '/exercises/${widget.selectedPart}/${widget.exerciseName}/images')
                          .child('${widget.exerciseName}_image.jpg')
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        try {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SpinKitRing(
                                color:
                                    kWhite); // Show a loading indicator while waiting
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); // Handle errors
                          } else if (snapshot.hasData) {
                            return Image.network(
                              snapshot.data as String,
                              fit: BoxFit.cover,
                            ); // Display the image
                          } else {
                            return const Text(
                                'No data available'); // Handle the case where there's no data
                          }
                        } on Exception catch (e) {
                          print(e);
                          return Text('$e');
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
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
                        if (widget.showAddButton)
                          GestureDetector(
                            onTap: () async {
                              final routines = await FirebaseFirestore.instance
                                  .collection('/users/${user?.uid}/routines')
                                  .get();
                              if (context.mounted) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => routines.docs.isEmpty
                                      ? const CreateRoutine()
                                      : SelectRoutine(
                                          exerciseName: widget.exerciseName,
                                          description:
                                              widget.exerciseDescription,
                                          selectedPart: widget.selectedPart,
                                        ),
                                );
                              }
                            },
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
                        if (!widget.showAddButton)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _removeMuscleGroupToRoutine(
                                    widget.selectedPart as String,
                                    widget.exerciseName,
                                    widget.exerciseDescription);
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Delete',
                                  style: kButtonsTextStyle.copyWith(
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.red[700],
                                  size: 24.22,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.chevron_left,
          size: 40,
          color: Colors.white,
        ));
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

        if (context.mounted) {
          Provider.of<RoutineData>(context).removeRoutine(widget.routineName);
        }
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
            child: Container(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.routineName,
                    style: kTitleTextStyle.copyWith(
                        fontWeight: FontWeight.normal, fontSize: 27),
                  ),
                  StreamBuilder(
                      stream: Provider.of<RoutineData>(context, listen: false)
                          .countFirebaseExercises(widget.routineName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
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
    required this.finalDescriptionsList,
    required this.finalSelectedPartList,
    super.key,
  });

  final String title;
  final List finalExercisesList;
  late bool isChecked;
  final List finalDescriptionsList;
  final List finalSelectedPartList;

  @override
  State<MuscleCheckboxListTile> createState() => _MuscleCheckboxListTileState();
}

User? user = FirebaseAuth.instance.currentUser;

class _MuscleCheckboxListTileState extends State<MuscleCheckboxListTile> {
  bool? _checked = false;
  List addedExercises = [];
  List addedDescriptions = [];
  List addedSelectedParts = [];

  void getMuscleExercices(
    String title,
    bool? checked,
    List finalExercisesList,
    List finalDescriptionList,
    List finalSelectedPartList,
    List addedExercises,
    List addedDescriptions,
    List addedSelectedParts,
  ) async {
    List exercisesList = [];
    List descriptionList = [];
    List selectedPartList = [];
    Set<int> setOfInts = {};

    if (checked!) {
      QuerySnapshot exercisesDocs = await FirebaseFirestore.instance
          .collection('/exercises/T8fpn99FZ0tOPWvwm22t/$title')
          .get();

      for (var exercise in exercisesDocs.docs) {
        var data = exercise.data() as Map<String, dynamic>;

        exercisesList.add(data['name']);
        descriptionList.add(data['description']);
        selectedPartList.add(data['selectedPart']);
      }

      while (setOfInts.length < 4 && setOfInts.length < exercisesList.length) {
        int randomIntValue = Random().nextInt(exercisesList.length);
        setOfInts.add(randomIntValue);
      }

      for (var i in setOfInts) {
        finalExercisesList.add(exercisesList[i]);
        addedExercises.add(exercisesList[i]);
        finalDescriptionList.add(descriptionList[i]);
        addedDescriptions.add(descriptionList[i]);
        finalSelectedPartList.add(selectedPartList[i]);
        addedSelectedParts.add(selectedPartList[i]);
      }
    } else {
      for (var exercises in addedExercises) {
        finalExercisesList.remove(exercises);
      }
      for (var description in addedDescriptions) {
        finalDescriptionList.remove(description);
      }
      for (var selectedPart in addedSelectedParts) {
        finalSelectedPartList.remove(selectedPart);
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
            widget.isChecked = true;
          });

          getMuscleExercices(
            widget.title,
            _checked,
            widget.finalExercisesList,
            widget.finalDescriptionsList,
            widget.finalSelectedPartList,
            addedExercises,
            addedDescriptions,
            addedSelectedParts,
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
