import 'package:body_part_selector/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExercisesListScreen extends StatefulWidget {
  ExercisesListScreen(
      {required this.muscleSelected, required this.selectedPart, super.key});

  late BodyParts muscleSelected;
  late String? selectedPart;


  @override
  State<ExercisesListScreen> createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const PopButton(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                  child: Text(
                    '${widget.selectedPart} Exercises:',
                    style: kTitleTextStyle.copyWith(fontSize: 25),
                  ),
                ),
                StreamBuilderExercises(
                  firestore: _firestore,
                  widget: widget,
                  selectedBodyParts: widget.muscleSelected,
                  collection: widget.selectedPart,
                  
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class StreamBuilderExercises extends StatelessWidget {
  const StreamBuilderExercises({
    super.key,
    required FirebaseFirestore firestore,
    required this.widget,
    required this.collection,
    required this.selectedBodyParts,
    
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final ExercisesListScreen widget;
  final String? collection;
  final BodyParts selectedBodyParts;
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection('/exercises/T8fpn99FZ0tOPWvwm22t/$collection')
            .snapshots(),
        builder: (context, snapshot) {
          List<Widget> exercisesButtonList = [];
          if (widget.muscleSelected == selectedBodyParts) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final exerciseList = snapshot.data!.docs;

            for (var exercises in exerciseList) {
              final String exerciseName = exercises.data()['name'];
              final String exerciseDescription =
                  exercises.data()['description'];

              final exerciseCard = ExerciseButton(
                exerciseName: exerciseName,
                exerciseDescription: exerciseDescription,
                showAddButton: true,
               
              );
              exercisesButtonList.add(exerciseCard);
            }
          }
          return Expanded(
              child: ListView(
            children: exercisesButtonList,
          ));
        });
  }
}
