import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/home/models/alarm_model.dart';

class AlarmListItem extends StatelessWidget {
  final AlarmModel alarm;
  final ValueChanged<bool> onToggle;

  const AlarmListItem({
    super.key,
    required this.alarm,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final String time = DateFormat.jm().format(alarm.dateTime);
    final String date = DateFormat('E d MMM yyyy').format(alarm.dateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          Switch(
            value: alarm.isActive,
            onChanged: onToggle,
            activeTrackColor: AppColors.primaryColor,
            activeColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}