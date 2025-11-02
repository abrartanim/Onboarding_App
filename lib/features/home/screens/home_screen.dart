import 'package:flutter/material.dart';
import 'package:softvence_project/constants/app_colors.dart';
import 'package:softvence_project/features/home/models/alarm_model.dart';
import 'package:softvence_project/features/home/widgets/alarm_list_item.dart';
import 'package:softvence_project/main.dart'; // Import to get notificationHelper

class HomeScreen extends StatefulWidget {
  final String? selectedLocation;

  const HomeScreen({super.key, this.selectedLocation});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<AlarmModel> _alarms = [];

  Future<void> _setAlarm() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime == null) return;

    final DateTime scheduledDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final newAlarm = AlarmModel(
      id: _alarms.length, // Simple ID for now
      dateTime: scheduledDateTime,
      isActive: true,
    );

    setState(() {
      _alarms.add(newAlarm);
    });

    await notificationHelper.scheduleNotification(
      id: newAlarm.id,
      title: 'Your Travel Alarm!',
      body: 'Time to get ready for your event at ${widget.selectedLocation ?? 'your destination'}!',
      scheduledTime: newAlarm.dateTime,
    );
  }

  void _onAlarmToggle(AlarmModel alarm, bool isActive) {
    setState(() {
      alarm.isActive = isActive;
    });

    if (isActive) {
      notificationHelper.scheduleNotification(
        id: alarm.id,
        title: 'Your Travel Alarm!',
        body: 'Time to get ready!',
        scheduledTime: alarm.dateTime,
      );
    } else {
      notificationHelper.cancelNotification(alarm.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Location'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.white),
                  const SizedBox(width: 12),
                  Text(
                    widget.selectedLocation ?? 'Add your location',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // "Alarms" Title
            Text(
              'Alarms',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Alarm List
            Expanded(
              child: _alarms.isEmpty
                  ? Center(
                child: Text(
                  'No alarms set.\nPress the + button to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _alarms.length,
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  return AlarmListItem(
                    alarm: alarm,
                    onToggle: (isActive) => _onAlarmToggle(alarm, isActive),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setAlarm,
        backgroundColor: AppColors.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white, size: 30),
      ),
    );
  }
}