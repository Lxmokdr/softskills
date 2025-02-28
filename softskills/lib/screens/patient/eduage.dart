import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/multiusebutton.dart';

class eduage extends StatefulWidget {
  const eduage({super.key});

  @override
  State<eduage> createState() => _eduageState();
}

class _eduageState extends State<eduage> {
  String education = 'add';
  String age = 'add';
  String? uid = Auth().getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SelectableDialogButton(
            title: 'Education',
            field: 'education',
            options: [
              'High School',
              'Diploma',
              'Bachelor\'s Degree',
              'Postgraduate'
            ],
            onUpdate: (value) {
              setState(() {
                education = value;
              });
            },
            backgroundColor: color.bgColor,
            uid: uid,
          ),
          const SizedBox(width: 10),
          SelectableDialogButton(
            title: 'Age',
            field: 'age',
            options: ['18-25', '26-35', '36-45', '46-55', '56-65', '66+'],
            onUpdate: (value) {
              setState(() {
                age = value;
              });
            },
            backgroundColor: color.bgColor,
            uid: uid,
          ),
        ],
      ),
    );
  }
}
