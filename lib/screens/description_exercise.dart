import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:flutter/material.dart';
import 'select_routine_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class DescriptionExercise extends StatefulWidget {
  const DescriptionExercise(
      {required this.exerciseName,
      required this.exerciseDescription,
      required this.showAddButton,
      required this.selectedPart,
      super.key});

  final String exerciseName;
  final String exerciseDescription;
  final String? selectedPart;

  final bool showAddButton;

  @override
  State<DescriptionExercise> createState() => _DescriptionExerciseState();
}

class _DescriptionExerciseState extends State<DescriptionExercise> {
  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.showAddButton
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SelectRoutine(
                    exerciseName: widget.exerciseName,
                    description: widget.exerciseDescription,
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
            const Positioned(
              top: 16,
              left: 10,
              child: PopButton(),
            ),
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
                    child: FutureBuilder(
                  future: FirebaseStorage.instance
                      .ref(
                          '/exercises/${widget.selectedPart}/${widget.exerciseName}/videos')
                      .child('${widget.exerciseName}_video.mp4')
                      .getDownloadURL(),
                  builder: (context, snapshot) {
                    print(widget.selectedPart);
                    print(widget.exerciseName);
                    print(snapshot.data);

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Handle errors
                    } else if (snapshot.hasData) {
                      // Initialize the VideoPlayerController with the download URL
                      final videoPlayerController =
                          VideoPlayerController.networkUrl(
                              Uri.parse(snapshot.data as String));

                      // You must call initialize on the controller and wait for it to complete before displaying the video
                      return FutureBuilder(
                        future: videoPlayerController.initialize(),
                        builder: (context, videoSnapshot) {
                          if (videoSnapshot.connectionState ==
                              ConnectionState.done) {
                            return AspectRatio(
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController),
                            );
                          } else {
                            return CircularProgressIndicator(); // Show loading indicator while video is being prepared
                          }
                        },
                      );
                    } else {
                      return Text(
                          'No data available'); // Handle the case where there's no data
                    }
                  },
                )),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10, right: 10, bottom: 10),
                          child: Text(
                            textAlign: TextAlign.justify,
                            widget.exerciseDescription,
                            style: kButtonsTextStyle.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        ),
                      ],
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
