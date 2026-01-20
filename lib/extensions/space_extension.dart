import 'package:flutter/material.dart';

extension SpacingExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());
}

///[Vertical space]
// Column(
//   children: [
//     Text('Title'),
//     16.height, // SizedBox(height: 16)
//     Text('Subtitle'),
//   ],
// );

/// [Horizontal space]
// Row(
//   children: [
//     Icon(Icons.star),
//     8.width, // SizedBox(width: 8)
//     Text('Rating'),
//   ],
// );

/// [All sides padding]
// Container(
//   padding: 12.allPadding, // EdgeInsets.all(12)
//   child: Text('Hello'),
// );

/// [Horizontal padding only]
// Padding(
//   padding: 20.horizontalPadding, // EdgeInsets.symmetric(horizontal: 20)
//   child: Text('Content'),
// );

/// [Vertical padding only]
// Padding(
//   padding: 10.verticalPadding, // EdgeInsets.symmetric(vertical: 10)
//   child: Text('Content'),
// );
