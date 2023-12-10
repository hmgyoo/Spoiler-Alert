import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite_v2/tflite_v2.dart';

import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  // final _database = FirebaseDatabase.instance.ref();
  // late StreamSubscription _fruitStream;
  // late final Stream<DatabaseEvent> stream =
  //     FirebaseDatabase.instance.ref('FRUITS/$recognizedlabel').onValue;

  String recognizedlabel = "";
  String _minTemp = '0';
  String _maxTemp = '0';
  String _frzPoint = '0';
  String _minHum = '0';
  String _maxHum = '0';
  String _minStorageLife = '0';
  String _maxStorageLife = '0';
  String _aveShelfLife = '0';

  final ImagePicker _picker = ImagePicker();
  String recognitionResultsText = "";
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";

  @override
  void initState() {
    // _activeListeners();
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  loadmodel() async {
    await Tflite.loadModel(
      // model: "assets/model_unquant.tflite",
      // labels: "assets/labels.txt",
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    int endTime = new DateTime.now().millisecondsSinceEpoch;

    // Use a StringBuilder
    var sb = StringBuffer();
    sb.writeln("==== Recognition Results ====");
    recognitions?.forEach((res) async {
      // get the label and store it in a string ob
      String label = res['label'];

      print(label);

      sb.writeln(
          "${(res["confidence"] * 100).toStringAsFixed(0)}% - ${res["label"]}");
      // Update the recognizedLabel variable
      setState(() {
        recognizedlabel = label;
      });

      // Update the Firebase Realtime Database
      await FirebaseDatabase.instance
          .ref('FRUITS')
          .update({'recognizedlabel': label});
    });
    sb.writeln("=============================");
    sb.writeln("Inference Time: ${endTime - startTime}ms");
    sb.writeln("============================="); // please work huhuuhhu
    sb.writeln();

    // Update the state
    setState(() {
      recognitionResultsText = sb.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    late final Stream<DatabaseEvent> stream =
        FirebaseDatabase.instance.ref('FRUITS/$recognizedlabel').onValue;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 20),
            Text(recognitionResultsText),
            StreamBuilder(
              stream: stream,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.snapshot.value as Map?;
                  if (data == null) {
                    return Text('No data');
                  }
                  final minTemp = data['minTemp'];
                  final maxTemp = data['maxTemp'];
                  final frzPoint = data['frzPoint'];
                  final minHum = data['minHum'];
                  final maxHum = data['maxHum'];
                  final minStorageLife = data['minStorageLife'];
                  final maxStorageLife = data['maxStorageLife'];
                  final aveShelfLife = data['aveShelfLife'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optimal Condition to avoid early Spoilage',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Min Temp (F): $minTemp',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Max Temp (F): $maxTemp',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Freezing Point (F): $frzPoint',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Min Humidity (%): $minHum',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Max Humidity (%): $maxHum',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Min Storage Life (days): $minStorageLife',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Max Storage Life (days): $maxStorageLife',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Average Shelf Life (days): $aveShelfLife',
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
            )
          ],
        ),
      ),
    );
  }
}
