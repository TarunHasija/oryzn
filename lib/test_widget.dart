// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:home_widget/home_widget.dart';

// /// Widget for testing purposes. Not used in the actual app.
// class TestWidget extends StatefulWidget {
//   const TestWidget({super.key});

//   @override
//   State<TestWidget> createState() => _TestWidgetState();
// }

// class _TestWidgetState extends State<TestWidget> {
//   int counter = 0;
//   String appGroupId = "group.homeScreenApp";
//   String iOSWidgetName = "MyHomeWidget";
//   String androidWidgetName = "MyHomeWidget";
//   String dataKey = "text_from_flutter_app";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     HomeWidget.setAppGroupId(appGroupId);
//   }

//   void increment() async {
//     setState(() {
//       counter++;
//     });

//     String data = "Count $counter";
//     await HomeWidget.updateWidget(
//       iOSName: iOSWidgetName,
//       androidName: androidWidgetName,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           increment();
//         },
//       ),
//       body: Center(child: Text(counter.toString())),
//     );
//   }
// }
