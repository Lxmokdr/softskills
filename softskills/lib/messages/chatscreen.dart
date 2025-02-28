import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/screens/common/profilepick.dart';
import 'package:http/http.dart' as http;
import '../screens/patient/download_helper.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const ChatScreen({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isRecording = false;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late ScrollController _scrollController;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  HMSSDK hmsSDK = HMSSDK();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeRecorder();
    hmsSDK.build();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _recorder.stopRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> downloadFilemessage(String fileURL, String fileName) async {
    if (fileURL.isNotEmpty) {
      if (kIsWeb) {
        downloadFile(fileURL, []);
      } else {
        try {
          final response = await http.get(Uri.parse(fileURL));
          if (response.statusCode == 200) {
            final directory = await getApplicationDocumentsDirectory();
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);

            await file.writeAsBytes(response.bodyBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$fileName téléchargé avec succès.")),
            );

            await openDownloadedFile(filePath);
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
        SnackBar(content: Text("Fichier non disponible.")),
      );
    }
  }

  Future<void> openDownloadedFile(String filePath) async {
    if (!kIsWeb) {
      final file = File(filePath);
      if (await file.exists()) {
        OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Le fichier n'existe pas!")),
        );
      }
    }
  }

  void _playOrPauseVoice(String url) async {
    if (_currentlyPlayingUrl == url) {
      await _audioPlayer.stop();
      setState(() => _currentlyPlayingUrl = null);
    } else {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _currentlyPlayingUrl = url);
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
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Microphone permission not granted")),
          );
          return;
        }
        await _recorder.startRecorder(toFile: 'voice.aac');
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint("Error during recording: $e");
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
          SnackBar(content: Text("$fileName envoyé avec succès")),
        );
      } catch (e) {
        debugPrint("Erreur lors de l'envoi du fichier: $e");
      }
    }
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return; // Don't send empty messages
    }

    try {
      String chatRoomDocId = ([currentUserId, widget.userId]..sort()).join('_');
      await firestore
          .collection('chatRooms')
          .doc(chatRoomDocId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'receiverId': widget.userId,
        'message': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void joinRoom(String authToken, {bool isVideo = true}) {
    HMSConfig config = HMSConfig(authToken: authToken, userName: currentUserId);

    hmsSDK.join(config: config).then((_) {
      if (!isVideo) {
        hmsSDK.switchVideo(isOn: false); // Disable video for voice call
      }
    });
  }

  Future<String?> getRoomIdFromFirestore(String receiverId) async {
    var doc = await FirebaseFirestore.instance
        .collection('calls')
        .doc(receiverId)
        .get();
    return doc.exists ? doc['roomId'] : null;
  }

  void saveRoomToFirestore(String receiverId, String roomId) {
    FirebaseFirestore.instance.collection('calls').doc(receiverId).set({
      "roomId": roomId,
      "callerId": currentUserId,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<String> createRoom() async {
    const String url =
        "https://prod-in.100ms.live/hmsapi/YOUR_APP_ID/api/v2/rooms";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization":
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NDA3MDAwNDEsImV4cCI6MTc0MTMwNDg0MSwianRpIjoiYTY4MTlhODMtY2UwMS00Nzg1LWJlNWMtYTRjY2FmMWRjYTdmIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJuYmYiOjE3NDA3MDAwNDEsImFjY2Vzc19rZXkiOiI2N2JlZWY3ZjMzY2U3NGFiOWJlOTU1ODAifQ.i1S1Gz89jDLiWfXBsGGDMvAEcKn0aoKP2XNU872cu_0", // Replace with actual management token
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name":
            "CallRoom-${DateTime.now().millisecondsSinceEpoch}", // Unique room name
        "template_id":
            "67beefbc4b6eb78daeed778b" // Replace with your template ID from 100ms
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id']; // Return newly created Room ID
    } else {
      throw Exception("Failed to create room: ${response.body}");
    }
  }

  Future<String> fetchAuthToken(String roomId, String role) async {
    const String url =
        "https://prod-in.100ms.live/hmsapi/YOUR_APP_ID/api/token";

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": currentUserId,
        "role": role, // 'audio' for voice calls, 'video' for video calls
        "type": "app",
        "room_id": roomId
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token']; // Return auth token
    } else {
      throw Exception("Failed to get token: ${response.body}");
    }
  }

  void startVoiceCall() async {
    String roomId = await createRoom(); // Step 1: Create a room
    String authToken =
        await fetchAuthToken(roomId, "audio"); // Step 2: Get token
    joinRoom(authToken, isVideo: false); // Step 3: Join room
  }

  void startVideoCall() async {
    String roomId = await createRoom(); // Step 1: Create a room
    String authToken =
        await fetchAuthToken(roomId, "video"); // Step 2: Get token
    joinRoom(authToken, isVideo: true); // Step 3: Join room
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ProfilePicture(uid: widget.userId),
            ),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.call), // Voice Call Icon
            onPressed: () {
              startVoiceCall();
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam), // Video Call Icon
            onPressed: () {
              startVideoCall();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(([currentUserId, widget.userId]..sort()).join('_'))
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData =
                        messages[index].data() as Map<String, dynamic>;
                    bool isSentByCurrentUser =
                        messageData['senderId'] == currentUserId;
                    DateTime timestamp =
                        (messageData['timestamp'] as Timestamp).toDate();
                    String formattedTime =
                        DateFormat('hh:mm a').format(timestamp);

                    Widget messageWidget;
                    if (messageData['voiceUrl'] != null) {
                      messageWidget = InkWell(
                        onTap: () => _playOrPauseVoice(messageData['voiceUrl']),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _currentlyPlayingUrl == messageData['voiceUrl']
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: isSentByCurrentUser
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Voice Message',
                              style: TextStyle(
                                color: isSentByCurrentUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
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
                        style: TextStyle(
                          color:
                              isSentByCurrentUser ? Colors.white : Colors.black,
                        ),
                      );
                    }

                    return Dismissible(
                      key: Key(messages[index].id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {},
                      background: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.grey[300],
                        child:
                            Text(formattedTime, style: TextStyle(fontSize: 12)),
                      ),
                      child: Align(
                        alignment: isSentByCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isSentByCurrentUser
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: messageWidget,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: _selectAndSendFile,
                  icon: const Icon(Icons.attach_file, color: Colors.blue),
                ),
                IconButton(
                  onPressed: _recordOrStop,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic,
                      color: Colors.red),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
