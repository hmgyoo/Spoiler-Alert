import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// final databaseReference = FirebaseDatabase.instance.ref().child('REALTIME');
FirebaseDatabase database = FirebaseDatabase.instance;

// class Fetch {
//   void getData() {
//     DatabaseReference refer = FirebaseDatabase.instance.ref('REALTIME/');
//     refer.onValue.listen((DatabaseEvent event) {
//       final Object? data = event.snapshot.value;
//       print((data as Map)['gas']);
//       print((data as Map)['humidity']);
//       print((data as Map)['temperature']);
//     });
//   }
// }

class SensorsView extends StatefulWidget {
  const SensorsView({super.key});

  @override
  _SensorsViewState createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {
  late final Stream<DatabaseEvent> stream =
      FirebaseDatabase.instance.ref('REALTIME/').onValue;

  // statement
  String spoiledText = 'Is your food spoiling or not?';
  int gasValue = 0;

  void changeText(int gValue) {
    Future.delayed(Duration.zero, () {
      if (gValue == 0) {
        setState(() {
          spoiledText =
              'Your food is ready to be eaten and stored. Please keep it at optimal condition to avoid early spoilage.';
        });
      } else {
        setState(() {
          spoiledText =
              'There is ammonia gas detected in your food. It indicates that it is in the process of spoiling. If possible, try to save it optimal condition or consider throwing it away.';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DatabaseReference ref = FirebaseDatabase.instance.ref('REALTIME/');
          await ref.set({
            'gas': 1152,
            'humidity': 71,
            'temperature': 1111.111,
          });
        },
        child: const Icon(Icons.update),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: stream,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.snapshot.value as Map?;
                  if (data == null) {
                    return Text('No data');
                  }
                  final gas = data['gas'];
                  changeText(gas); // update the text
                  final humidity = data['humidity'];
                  final temperature = data['temperature'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'gas: $gas',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'humidity: $humidity',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'pressure: $temperature',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text(snapshot.error.toString());
                }

                return Text('....');
              },
            ),
            SizedBox(height: 20),
            // change text depends on value of gas sensor
            Text(spoiledText),
          ],
        ),
      ),
    );
  }
}
