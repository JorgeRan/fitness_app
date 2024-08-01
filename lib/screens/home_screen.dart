import 'package:fitness_app/screens/routines_screen.dart';
import 'package:flutter/material.dart';
import 'package:body_part_selector/body_part_selector.dart';
import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'exercises_list_screen.dart';
import 'package:fitness_app/routine_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

String selectedSide = "Front";

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.routineName, super.key});

  final String? routineName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BodyParts _bodyParts = const BodyParts();
  late BodySide bodySide = BodySide.front;
  String? selectedPart;
  RoutineData routineData = RoutineData();
  late bool tempBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 228,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: 205,
                  color: const Color(0xFF4535C1),
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Welcome 👋\nto Fitness App!',
                            textAlign: TextAlign.left,
                            style: kTitleTextStyle.copyWith(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 15,
                                  top: 2,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.dumbbell,
                                  color: Color(0xFF4535C1),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Select a muscle to get started',
                        textAlign: TextAlign.left,
                        style: kTitleTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF36C2CE)),
                      onPressed: () {
                        routineData.addFirebaseRoutines;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RoutinesScreen(
                                      routineName: widget.routineName,
                                    )));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.personRunning,
                            color: Colors.white,
                          ),
                          Text(
                            'Routines',
                            style: kButtonsTextStyle,
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 202,
              height: 464,
              child: BodyPartSelector(
                bodyParts: _bodyParts,
                onSelectionUpdated: (p) {
                  setState(
                    () {
                      bool hasSelected = false;

                      if (p.upperBody &&
                          (selectedPart == null ||
                              selectedPart != "Upper Body") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(upperBody: true);
                        selectedPart = "Upper Body";
                        hasSelected = true;
                      }
                      if (p.abdomen &&
                          (selectedPart == null ||
                              selectedPart != "Adductors") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(abdomen: true);
                        selectedPart = "Adductors";
                        hasSelected = true;
                      }

                      if (p.leftShoulder &&
                          (selectedPart == null ||
                              selectedPart != "Shoulders") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            leftShoulder: true, rightShoulder: true);
                        selectedPart = "Shoulders";
                        hasSelected = true;
                      }
                      if (p.rightShoulder &&
                          (selectedPart == null ||
                              selectedPart != "Shoulders") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightShoulder: true, leftShoulder: true);
                        selectedPart = "Shoulders";
                        hasSelected = true;
                      }
                      if (p.leftUpperArm &&
                          (selectedPart == null || selectedPart != "Arms") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            leftUpperArm: true, rightUpperArm: true);
                        selectedPart = "Arms";
                        hasSelected = true;
                      }
                      if (p.rightUpperArm &&
                          (selectedPart == null || selectedPart != "Arms") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightUpperArm: true, leftUpperArm: true);
                        selectedPart = "Arms";
                        hasSelected = true;
                      }

                      if (p.leftLowerArm &&
                          (selectedPart == null ||
                              selectedPart != "ForeArms") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            leftLowerArm: true, rightLowerArm: true);
                        selectedPart = "ForeArms";
                        hasSelected = true;
                      }
                      if (p.rightLowerArm &&
                          (selectedPart == null ||
                              selectedPart != "ForeArms") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightLowerArm: true, leftLowerArm: true);
                        selectedPart = "ForeArms";
                        hasSelected = true;
                      }

                      if (p.vestibular &&
                          (selectedPart == null || selectedPart != "Abs") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(vestibular: true);
                        selectedPart = "Abs";
                        hasSelected = true;
                      }
                      if (p.lowerBody &&
                          (selectedPart == null || selectedPart != "Abs") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(lowerBody: true);
                        selectedPart = "Abs";
                        hasSelected = true;
                      }

                      if (p.leftUpperLeg &&
                          (selectedPart != "Legs" || selectedPart == null) &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            leftUpperLeg: true, rightUpperLeg: true);
                        selectedPart = "Legs";
                        hasSelected = true;
                      }

                      if (p.rightUpperLeg &&
                          (selectedPart == null || selectedPart != "Legs") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightUpperLeg: true, leftUpperLeg: true);
                        selectedPart = "Legs";
                        hasSelected = true;
                      }

                      if (p.rightLowerLeg &&
                          (selectedPart == null || selectedPart != "Calves") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightLowerLeg: true, leftLowerLeg: true);
                        selectedPart = "Calves";
                        hasSelected = true;
                      }

                      if (p.leftLowerLeg &&
                          (selectedPart == null || selectedPart != "Calves") &&
                          !hasSelected) {
                        _bodyParts = const BodyParts(
                            rightLowerLeg: true, leftLowerLeg: true);
                        selectedPart = "Calves";
                        hasSelected = true;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ExercisesListScreen(
                                  muscleSelected: _bodyParts,
                                  selectedPart: selectedPart,
                                )),
                      );
                    },
                  );
                },
                side: bodySide,
                selectedColor: kCyan,
                unselectedColor: kWhite,
                selectedOutlineColor: Colors.black,
                unselectedOutlineColor: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodySideButton(
                  sideText: 'Front',
                  onTap: () {
                    selectedSide = "Front";
                    bodySide = BodySide.front;

                    setState(() {});
                  },
                ),
                BodySideButton(
                  sideText: 'Back',
                  onTap: () {
                    selectedSide = "Back";
                    bodySide = BodySide.back;

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
