import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

class ExercisesAssests {
  final String videoLink = '';
  late VideoPlayerController _videoPlayerController;

  videoStream(String selectedPart, String exerciseName) {
    return FutureBuilder(
      future: FirebaseStorage.instance
          .ref('/exercises/${selectedPart}/${exerciseName}/videos')
          .child('${exerciseName}_video.mp4')
          .getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          _videoPlayerController = VideoPlayerController.networkUrl(
            Uri.parse(snapshot.data as String),
          );

          return SizedBox(
            width: double.infinity,
            child: VideoPlayer(_videoPlayerController),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
