// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/sideMenu.dart';

class Doctors extends StatelessWidget {
  const Doctors({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:  SideMenu(),
      backgroundColor: color.bgColor,
      appBar: AppBar(
        title: const Text("Choisi ton docteur"),
        actions: [
            IconButton(
              onPressed: () async {
                showDialog(context: context,
                builder : (BuildContext context ){
                  return AlertDialog(
                  title: const Text('filter'),
                  actions: [
                    ListTile(
                                title: const Text("Femmes"),
                                leading: Radio<String>(
                                  value: "women",
                                  groupValue: null,
                                  onChanged: (String? value) {
                                    Navigator.pop(context);
                                    print("Filter on women");
                                  },
                                ),
                              ),
                     ListTile(
                                title: const Text("Hommes"),
                                leading: Radio<String>(
                                  value: "homme",
                                  groupValue: null,
                                  onChanged: (String? value) {
                                    Navigator.pop(context);
                                    print("Filter on men");
                                  },
                                ),
                              ),
                  ],);
                }
                );
              },
              icon: const Icon(Icons.filter_list, color: Colors.white,), 
              color: Colors.white,
            ),
          ],
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ElevatedButton(
              onPressed: () async {
                // Step 1: Show the date picker
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2026),
                );

                if (selectedDate != null) {
                  print("Selected date: ${selectedDate.toLocal()}");

                  // Step 2: Show the time picker
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    final selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    print("Selected Date and Time: $selectedDateTime");

                    // Step 3: Show payment method dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Select Payment Method"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("BCIB Card"),
                                leading: Radio<String>(
                                  value: "CIB Card",
                                  groupValue: null,
                                  onChanged: (String? value) {
                                    Navigator.pop(context); // Close dialog on selection
                                    print("Payment method: CIB Card");
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text("Edahabiya Card"),
                                leading: Radio<String>(
                                  value: "Edahabiya Card",
                                  groupValue: null,
                                  onChanged: (String? value) {
                                    Navigator.pop(context); // Close dialog
                                    // Step 4: Show Edahabiya card info input form
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Enter Edahabiya Card Info",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 16),
                                                // Card Number
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: "Card Number",
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                                const SizedBox(height: 16),
                                                // Expiration Date Dropdown (Month and Year)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: DropdownButtonFormField<String>(
                                                        decoration: const InputDecoration(
                                                          labelText: "Month",
                                                          border: OutlineInputBorder(),
                                                        ),
                                                        items: List.generate(12, (index) {
                                                          return DropdownMenuItem(
                                                            value: (index + 1).toString().padLeft(2, '0'),
                                                            child: Text((index + 1).toString().padLeft(2, '0')),
                                                          );
                                                        }),
                                                        onChanged: (value) {
                                                          print("Selected month: $value");
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: DropdownButtonFormField<String>(
                                                        decoration: const InputDecoration(
                                                          labelText: "Year",
                                                          border: OutlineInputBorder(),
                                                        ),
                                                        items: List.generate(10, (index) {
                                                          int year = DateTime.now().year + index;
                                                          return DropdownMenuItem(
                                                            value: year.toString(),
                                                            child: Text(year.toString()),
                                                          );
                                                        }),
                                                        onChanged: (value) {
                                                          print("Selected year: $value");
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),
                                                // CVV
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: "CVV",
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                                const SizedBox(height: 16),
                                                // Submit Button
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle payment processing here
                                                    Navigator.pop(context); // Close the bottom sheet
                                                    print("Card information submitted");
                                                  },
                                                  child: const Text("Submit"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context); // Close dialog without selection
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                backgroundColor: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Centers vertically
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name', style: Textstyle.darkText),
                        Text('Psychologue', style: Textstyle.smallerDarkGreenTexte),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 70, // Space to push the price down
                        ),
                        Text('price Da/session', style: Textstyle.smallerDarkGreenTexte),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),        
                ],
              ),
              );
            }
          }