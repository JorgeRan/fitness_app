import 'package:fitness_app/constants.dart';
import 'package:fitness_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  VideoPlayerController? _videoPlayerController;

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
                    selectedPart: widget.selectedPart,
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
                SizedBox(
                    width: double.infinity,
                    child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref(
                              '/exercises/${widget.selectedPart}/${widget.exerciseName}/videos')
                          .child('${widget.exerciseName}_video.mp4')
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Row(
                            children: [
                              Spacer(),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: SpinKitRing(color: kWhite),
                              ),
                              Spacer(),
                            ],
                          );
                        } else if (snapshot.hasData) {
                          _videoPlayerController =
                              VideoPlayerController.networkUrl(
                            Uri.parse(snapshot.data as String),
                          );

                          return FutureBuilder(
                            future: _videoPlayerController!.initialize(),
                            builder: (context, videoSnapshot) {
                              if (videoSnapshot.connectionState ==
                                  ConnectionState.done) {
                                _videoPlayerController!.play();
                                _videoPlayerController!.setLooping(true);

                                return AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController!),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          );
                        } else {
                          return const Text('No data available');
                        }
                      },
                    )),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0XFF36C2CE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, right: 10, bottom: 10),
                      child: Text(
                        textAlign: TextAlign.justify,
                        widget.exerciseDescription,
                        style: kButtonsTextStyle.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 18),
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

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
