import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/routine_data.dart';
import 'package:fitness_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(
        child: Text('User is not logged in'),
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('/users/${user.uid}/routines/')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Text('No Routines'),
            );
          }
          final routineList = snapshot.data!.docs;

          Provider.of<RoutineData>(context, listen: false)
              .routineButtonList
              .clear();

          for (var routine in routineList) {
            final routineName = routine.data()['routineName'];
            Provider.of<RoutineData>(context, listen: false)
                .routineButtonList
                .add(RoutineButton(routineName: routineName));
          }

          return ListView.builder(
              itemCount:
                  Provider.of<RoutineData>(context).routineButtonList.length,
              itemBuilder: (context, index) {
                final routine =
                    Provider.of<RoutineData>(context).routineButtonList[index];

                return routine;
              });
        });
  }
}
