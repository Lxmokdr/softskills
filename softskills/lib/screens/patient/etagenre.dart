import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/screens/common/multiusebutton.dart';

class etagenre extends StatefulWidget {
  const etagenre({super.key});

  @override
  State<etagenre> createState() => _etagenreState();
}

class _etagenreState extends State<etagenre> {
  String civil = 'add';
  String genre = 'add';
  String? uid = Auth().getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SelectableDialogButton(
            title: 'Etat Civil',
            field: 'civil',
            options: [
              'Marié(e)',
              'Divorcé(e)',
              'Célibataire',
              'Ne pas spécifier',
            ],
            onUpdate: (value) {
              setState(() {
                civil = value;
              });
            },
            backgroundColor: color.bgColor,
            uid: uid,
          ),
          const SizedBox(
            width: 10,
          ),
          SelectableDialogButton(
            title: 'Genre',
            field: 'genre',
            options: ['Homme', 'Femme'],
            onUpdate: (value) {
              setState(() {
                civil = value;
              });
            },
            backgroundColor: color.bgColor,
            uid: uid,
          )
        ],
      ),
    );
  }
}
