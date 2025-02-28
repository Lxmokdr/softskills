import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(String fileName, List<int> bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsBytes(bytes);
  print("File saved at: ${file.path}");
}
