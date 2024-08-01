import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:flutter/material.dart';
import 'select_routine_screen.dart';

class DescriptionExercise extends StatefulWidget {
  const DescriptionExercise(
      {required this.exerciseName,
      required this.exerciseDescription,
      
      required this.showAddButton,

      super.key});

  final String exerciseName;
  final String exerciseDescription;
  
  final bool showAddButton;

  @override
  State<DescriptionExercise> createState() => _DescriptionExerciseState();
}

class _DescriptionExerciseState extends State<DescriptionExercise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  widget.showAddButton
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SelectRoutine(
                    exerciseName: widget.exerciseName,
                  ),
                );
              },
              backgroundColor: const Color(0xFF4535C1),
              elevation: elevationButtons,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.add_sharp,
                size: 40,
                color: Color(0XFF36C2CE),
              ),
            )
          : null, 
    
      
      body: SafeArea(
        child: Stack(
          children: [
            const PopButton(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.exerciseName,
                    style: kTitleTextStyle.copyWith(fontSize: 25),
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    'images/dumbell.png',
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0XFF36C2CE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 10, right: 10, bottom: 10),
                            child: Text(
                              widget.exerciseDescription,
                              style: kButtonsTextStyle.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
