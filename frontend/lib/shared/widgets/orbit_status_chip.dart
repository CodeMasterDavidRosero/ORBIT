import 'package:flutter/material.dart';
import '../../core/theme/orbit_colors.dart';

class OrbitStatusChip extends StatelessWidget {
  const OrbitStatusChip({
    super.key,
    required this.label,
    required this.positive,
  });

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: BorderSide.none,
      backgroundColor:
          positive ? OrbitColors.successSoft : OrbitColors.warningSoft,
      labelStyle: TextStyle(
        color: positive ? OrbitColors.success : OrbitColors.warning,
        fontSize: 12,
      ),
    );
  }
}
