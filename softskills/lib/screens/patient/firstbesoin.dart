import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/multiusebutton.dart';

class firstbesoin extends StatefulWidget {
  const firstbesoin({super.key});

  @override
  State<firstbesoin> createState() => _firstbesoinState();
}

class _firstbesoinState extends State<firstbesoin> {
  String besoin = 'add';
  String isFirst = 'add';
  String? uid = Auth().getCurrentUserId();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SelectableDialogButton(
              title: 'Est-ce votre première expérience en psychologie ?',
              field: 'isFirst',
              options: ['oui', 'non'],
              onUpdate: (value) {
                setState(() {
                  isFirst = value;
                });
              },
              backgroundColor: color.bgColor,
              uid: uid,
            ),
          ],
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              SelectableDialogButton(
                title: 'De quel genre d\'aide avez vous besoin ? ',
                field: 'besoin',
                options: [
                  'Developpement personnel',
                  'Problèmes familliaux',
                  'Depression',
                  'Stress'
                ],
                onUpdate: (value) {
                  setState(() {
                    besoin = value;
                  });
                },
                backgroundColor: color.bgColor,
                uid: uid,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
