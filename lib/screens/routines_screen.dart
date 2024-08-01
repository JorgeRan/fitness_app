import 'package:fitness_app/constants.dart';
import 'package:fitness_app/screens/create_routine.dart';
import 'package:fitness_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/routine_list.dart';
import 'package:fitness_app/routine_data.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({required this.routineName, super.key});

  final String? routineName;

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  @override
  void initState() {
    RoutineData().countFirebaseExercises(widget.routineName);
    RoutineData().addFirebaseRoutines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  left: 28, right: 35, top: 40, bottom: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PopButton(),
                  Text(
                    'Routines',
                    style: kTitleTextStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFF4535C1),
                ),
                width: double.infinity,
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 82.0),
                      child: RoutineList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: const CreateRoutine(),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_rounded,
                                size: 40,
                                color: Color(0XFF36C2CE),
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(55, 0, 0, 0),
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'New Routine',
                                style: kButtonsTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0XFF36C2CE),
                                    shadows: [
                                      const Shadow(
                                        color: Color.fromARGB(55, 0, 0, 0),
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
