import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker {
  static Future<String?> pickDay(BuildContext context) async {
    List<String> days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélectionnez un jour'),
          content: SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(days[index]),
                  onTap: () {
                    Navigator.pop(context, days[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future<String?> pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      int roundedMinute = (pickedTime.minute / 5).round() * 5;
      pickedTime = pickedTime.replacing(minute: roundedMinute % 60);

      final formattedTime = DateFormat('h:mm a').format(
        DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute),
      );

      return formattedTime;
    }
    return null;
  }
}
