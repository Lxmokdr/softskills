import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softskills/classes/color.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorCalendar extends StatefulWidget {
  final String patientUid;
  final String doctorUid;

  DoctorCalendar({required this.patientUid, required this.doctorUid});

  @override
  _DoctorCalendarState createState() => _DoctorCalendarState();
}

class _DoctorCalendarState extends State<DoctorCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _availableDays = [];
  Map<String, List<String>> _availableTimes = {};
  Map<DateTime, List<String>> _bookedTimesPerDay = {};

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
    _fetchBookings();
    _startAvailabilityListener();
  }

  void _startAvailabilityListener() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorUid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _fetchAvailability();
      }
    });
  }

  Future<void> _fetchBookings() async {
    final bookingSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorUid)
        .collection('consultations')
        .get();

    Map<DateTime, List<String>> bookedTimesPerDay = {};

    for (var doc in bookingSnapshot.docs) {
      final date = (doc.data()['date'] as Timestamp).toDate();
      final time = doc.data()['time'] as String;
      final dayOnly = DateTime(date.year, date.month, date.day);

      bookedTimesPerDay.putIfAbsent(dayOnly, () => []).add(time);
    }

    setState(() {
      _bookedTimesPerDay = bookedTimesPerDay;
    });
  }

  Future<void> _fetchAvailability() async {
    try {
      final availabilitiesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.doctorUid)
          .collection('availabilities') // Access the subcollection
          .get();

      if (availabilitiesSnapshot.docs.isNotEmpty) {
        Map<String, List<String>> tempAvailableTimes = {};
        List<DateTime> tempAvailableDays = [];

        for (var doc in availabilitiesSnapshot.docs) {
          String dayString = doc['day']; // Fetch day from the document
          String time = doc['time']; // Fetch time from the document

          tempAvailableTimes.putIfAbsent(dayString, () => []).add(time);

          DateTime availableDay = _getDayFromString(dayString);
          if (!tempAvailableDays.contains(availableDay)) {
            tempAvailableDays.add(availableDay);
          }
        }

        setState(() {
          _availableTimes = tempAvailableTimes;
          _availableDays = tempAvailableDays;
        });

        _generateWeeklyAvailability();
      }
    } catch (e) {
      print("Error fetching availability: $e");
    }
  }

  void _generateWeeklyAvailability() {
    final now = DateTime.now();
    final nextYear = DateTime(now.year + 1, now.month, now.day);

    List<DateTime> repeatedAvailableDays = [];

    for (DateTime date = now;
        date.isBefore(nextYear);
        date = date.add(Duration(days: 1))) {
      String dayName = getWeekdayName(date);

      // Check if this day exists in _availableTimes
      if (_availableTimes.containsKey(dayName)) {
        repeatedAvailableDays.add(DateTime(date.year, date.month, date.day));
      }
    }

    setState(() {
      _availableDays = repeatedAvailableDays;
    });
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    String selectedDayName = getWeekdayName(selectedDay);

    if (_availableTimes.containsKey(selectedDayName) &&
        !_isFullyBooked(selectedDay)) {
      _selectTimeForDay(selectedDayName, selectedDay);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$selectedDay is not available for booking.'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  DateTime _getDayFromString(String dayString) {
    final now = DateTime.now();
    final frenchDays = [
      "Dimanche",
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi"
    ];
    int weekdayIndex = frenchDays.indexOf(dayString);

    if (weekdayIndex == -1) {
      throw Exception('Invalid day string: $dayString');
    }

    int daysToAdd = (weekdayIndex - now.weekday + 7) % 7;
    DateTime targetDate = now.add(Duration(days: daysToAdd));
    return DateTime(targetDate.year, targetDate.month, targetDate.day);
  }

  bool _isFullyBooked(DateTime date) {
    final dayOnly = DateTime(date.year, date.month, date.day);
    final weekdayName = getWeekdayName(dayOnly);

    final availableTimes = _availableTimes[weekdayName] ?? [];
    final bookedTimes = _bookedTimesPerDay[dayOnly] ?? [];

    return availableTimes.isNotEmpty &&
        availableTimes.length == bookedTimes.length;
  }

  void _selectTimeForDay(String dayName, DateTime selectedDay) {
    final availableTimes = _availableTimes[dayName] ?? [];

    if (availableTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No available times for this day')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Time Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableTimes.map((time) {
              return ListTile(
                title: Text(time),
                onTap: () {
                  Navigator.of(context).pop();
                  _bookConsultation(selectedDay, time);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String getWeekdayName(DateTime date) {
    final frenchDays = [
      "Dimanche",
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi"
    ];
    return frenchDays[date.weekday % 7];
  }

  Future<void> _bookConsultation(DateTime date, String time) async {
    final consultationRef = FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorUid)
        .collection('consultations')
        .doc('${date.toIso8601String().split('T')[0]}_$time');

    await consultationRef.set({
      'date': Timestamp.fromDate(date),
      'time': time,
      'patientUid': widget.patientUid,
    });

    setState(() {
      final dayOnly = DateTime(date.year, date.month, date.day);
      _bookedTimesPerDay[dayOnly] = (_bookedTimesPerDay[dayOnly] ?? [])
        ..add(time);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Consultation booked for $date at $time')),
    );

    // Navigate back to the previous page after booking
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 237, 224),
      appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: color.bgColor,
          title: Text(
            "Doctor's Availability",
            style: TextStyle(color: Colors.white),
          )),
      body: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        calendarFormat: _calendarFormat,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final dayOnly = DateTime(day.year, day.month, day.day);

            if (_availableDays.contains(dayOnly)) {
              return Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isFullyBooked(day) ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(day.day.toString())),
              );
            }
            return null;
          },
        ),
        onDaySelected: _handleDaySelected,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }
}
