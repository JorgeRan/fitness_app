import 'package:cloud_firestore/cloud_firestore.dart';

void scriptDAta() async {
  var absCollection = FirebaseFirestore.instance
      .collection('exercises')
      .doc('T8fpn99FZ0tOPWvwm22t')
      .collection('Upper Body');

  QuerySnapshot querySnapshot = await absCollection.get();

  for (var doc in querySnapshot.docs) {
    await absCollection.doc(doc.id).update({
      'selectedPart': 'Upper Body',
    });
  }
  print('Script Finished');
}
