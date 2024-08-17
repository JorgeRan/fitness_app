import 'package:flutter/material.dart';
import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoutineExercisesScreen extends StatefulWidget {
  const RoutineExercisesScreen({required this.routineName, super.key});

  final String routineName;

  @override
  State<RoutineExercisesScreen> createState() => _RoutineExercisesScreenState();
}

class _RoutineExercisesScreenState extends State<RoutineExercisesScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 16,
              left: 10,
              child: PopButton(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 33),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                      child: Text(
                        widget.routineName,
                        style: kTitleTextStyle.copyWith(fontSize: 25),
                      ),
                    ),
                    StreamBuilderExercises(
                      firestore: _firestore,
                      routineName: widget.routineName,
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
  StreamBuilderExercises({
    super.key,
    required FirebaseFirestore firestore,
    required this.routineName,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  final String routineName;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .doc('/users/${user!.uid}/routines/$routineName/')
            .snapshots(),
        builder: (context, snapshot) {
          List<Widget> exercisesButtonList = [];

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final exerciseList = snapshot.data!.data()!['exercises'];
          final descriptionList = snapshot.data!.data()!['descriptions'];
          final selectedPartList = snapshot.data!.data()!['selectedParts'];

          for (int i = 0; i < exerciseList.length; i++) {
            final exerciseName = exerciseList[i];
            final exerciseDescription = descriptionList[i];
            final selectedPart = selectedPartList[i];

            final exerciseCard = ExerciseButton(
              routineName: routineName,
              exerciseName: exerciseName,
              exerciseDescription: exerciseDescription,
              selectedPart: selectedPart,
              showAddButton: false,
            );
            exercisesButtonList.add(exerciseCard);
          }

          return Expanded(
              child: ListView(
            children: exercisesButtonList,
          ));
        });
  }
}
