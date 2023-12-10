// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:tflite/tflite.dart';

// class TfliteModel extends StatefulWidget {
//   const TfliteModel({super.key});

//   @override
//   State<TfliteModel> createState() => _TfliteModelState();
// }

// class _TfliteModelState extends State<TfliteModel> {
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future loadModel() async {
//     Tflite.close();
//     String res;
//     res = (await Tflite.loadModel(
//         model: "assets/model_final_25epochs.tflite", labels: "labels.txt"))!;
//     print("Models loading status: $res");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Fruits and Veggies Classifier"),
//       ),
//       body: ListView(
//         children: [],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: pickImage,
//         tooltip: "Pick Image",
//         child: const Icon(Icons.image),
//       ),
//     );
//   }

//   Future pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     File image = File(pickedFile!.path);
//   }
// }
