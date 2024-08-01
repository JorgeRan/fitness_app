import 'package:fitness_app/routine_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RoutineList extends StatelessWidget {
  const RoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Provider.of<RoutineData>(context).routineButtonList.length,
        itemBuilder: (context, index) {
          final routine =
              Provider.of<RoutineData>(context).routineButtonList[index];

          return routine;
        });
  }
}
