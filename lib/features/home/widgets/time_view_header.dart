import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../extensions/extensions.dart';

class TimeViewHeader extends StatelessWidget {
  final Widget trailing;
  const TimeViewHeader({super.key, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEE, d MMM y').format(DateTime.now()),
            style: context.bodyMedium,
          ),
          trailing,
        ],
      ),
    );
  }
}
