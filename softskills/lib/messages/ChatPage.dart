import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:http/http.dart' as http;
import '../screens/patient/download_helper.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatPage({required this.userId, required this.userName, Key? key})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission not granted")),
      );
    }
  }

  Future<void> _sendVoiceMessage(String filePath) async {
    try {
      String chatRoomDocId = ([currentUserId, widget.userId]..sort()).join('_');
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.aac';

      final storageRef =
          FirebaseStorage.instance.ref('voiceMessages/$fileName');
      await storageRef.putFile(File(filePath));

      String downloadUrl = await storageRef.getDownloadURL();

      await firestore
          .collection('chatRooms')
          .doc(chatRoomDocId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': widget.userId,
        'message': 'Voice Message',
        'voiceUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voice message sent")),
      );
    } catch (e) {
      debugPrint("Error sending voice message: $e");
    }
  }

  Future<void> _selectAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      String chatRoomDocId = ([currentUserId, widget.userId]..sort()).join('_');

      try {
        final storageRef = FirebaseStorage.instance.ref('chatFiles/$fileName');
        await storageRef.putFile(File(filePath));

        String downloadUrl = await storageRef.getDownloadURL();

        await firestore
            .collection('chatRooms')
            .doc(chatRoomDocId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'receiverId': widget.userId,
          'message': 'File: $fileName',
          'fileUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File sent successfully")),
        );
      } catch (e) {
        debugPrint("Error sending file: $e");
      }
    }
  }

  Future<void> openDownloadedFile(String fileURL) async {
    if (!kIsWeb) {
      // ignore: unused_local_variable
      final directory = await getApplicationDocumentsDirectory();
      final file = File(fileURL);

      if (await file.exists()) {
        OpenFile.open(fileURL);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Le fichier n'existe pas!")),
        );
      }
    }
  }

  Future<void> downloadFilemessage(String fileURL, String fileName) async {
    if (fileURL.isNotEmpty) {
      if (kIsWeb) {
        // Directly trigger download on web
        downloadFile(fileURL, []);
      } else {
        try {
          final response = await http.get(Uri.parse(fileURL));
          if (response.statusCode == 200) {
            downloadFile(fileName, response.bodyBytes);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$fileName téléchargé avec succès.")),
            );
            await openDownloadedFile(fileURL);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur lors du téléchargement.")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec du téléchargement: $e")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("CV non disponible.")),
      );
    }
  }

  Future<void> _recordOrStop() async {
    try {
      if (_isRecording) {
        String? path = await _recorder.stopRecorder();
        setState(() => _isRecording = false);
        if (path != null && path.isNotEmpty) {
          await _sendVoiceMessage(path);
        }
      } else {
        await _recorder.startRecorder(toFile: 'voice.aac');
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint("Error during recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ProfilePicture(uid: widget.userId),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(fontSize: 18)),
          ],
        ),
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chatRooms')
                  .doc(([currentUserId, widget.userId]..sort()).join('_'))
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loading());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>?;
                    if (messageData == null) return const SizedBox.shrink();

                    bool isSentByCurrentUser =
                        messageData['senderId'] == currentUserId;

                    Widget messageWidget;
                    if (messageData['voiceUrl'] != null) {
                      messageWidget = InkWell(
                        onTap: () {
                          // Handle playback
                        },
                        child: const Text(
                          '🎙 Voice Message (Tap to play)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      );
                    } else if (messageData['fileUrl'] != null) {
                      messageWidget = InkWell(
                        onTap: () {
                          downloadFilemessage(
                              messageData['fileUrl'], messageData['message']);
                        },
                        child: Text(
                          '📄 File: ${messageData['message']}',
                          style: const TextStyle(
                              color: color.bgColor,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      messageWidget = Text(
                        messageData['message'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      );
                    }

                    return Align(
                      alignment: isSentByCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSentByCurrentUser
                              ? color.bgColor
                              : const Color.fromARGB(164, 9, 30, 58),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: messageWidget,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                  color: _isRecording ? Colors.red : color.bgColor,
                  onPressed: _recordOrStop,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _selectAndSendFile,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                        hintText: 'Enter message',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: color.bgColor,
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    final String message = messageController.text.trim();
    if (message.isNotEmpty) {
      String chatRoomDocId = ([currentUserId, widget.userId]..sort()).join('_');

      firestore
          .collection('chatRooms')
          .doc(chatRoomDocId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': widget.userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController.clear();
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    messageController.dispose();
    super.dispose;
  }
}
