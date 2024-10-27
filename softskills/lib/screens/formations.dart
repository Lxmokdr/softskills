import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/classes/textstyle.dart';
import 'package:softskills/screens/sideMenu.dart';

class Formation extends StatelessWidget {
  const Formation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.bgColor,
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Choisi une formation'),
        backgroundColor: color.darkBluerColor,
      ),
      //column containing the columns ta3 formations
      body:   Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:const EdgeInsets.all(20),
            child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0)
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
                        Text('date'),
                        Text('time')
                      ],
                    ),
                  ),
                   Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
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
                                          title: const Text("CIB Card"),
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
                          },
                          style:ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            backgroundColor: color.bgColor,
                        ), 
                          child: const Text('Enroll', style: Textstyle.smallerWhiteTexte,), ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('price Da/session', style: Textstyle.smallerDarkGreenTexte),
                      ],
                    ),
                  ),
                ],
              ),
          ),
          )
        ],
      ),
    );
  }
}