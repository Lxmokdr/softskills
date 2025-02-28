import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:softskills/classes/color.dart';
import 'package:softskills/firebase/auth.dart';
import 'package:softskills/messages/chatscreen.dart';
import 'package:softskills/screens/common/loading.dart';
import 'package:softskills/screens/common/profilepick.dart';

class MessageListPage extends StatefulWidget {
  const MessageListPage({Key? key}) : super(key: key);

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  final _auth = Auth();
  String? currentUid;
  String? currentUserName;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    currentUid = _auth.getCurrentUserId();
    if (currentUid != null) {
      currentUserName = await getUserInfo(uid: currentUid!, info: "name");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        centerTitle: true,
        backgroundColor: color.bgColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          var userList = snapshot.data!.docs.where((user) {
            return user.id !=
                currentUid; // Compare document ID instead of 'uid'
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              var user = userList[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: SizedBox(
                    width: 40, // Adjust width
                    height: 40, // Adjust height
                    child: ProfilePicture(uid: user.id),
                  ),
                  title: Text(
                    user['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(user['email'] ?? 'No email'),
                  trailing: const Icon(
                    Icons.message,
                    color: color.bgColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userName: user['name'] ?? 'Unknown',
                          userId: user.id, // Use document ID as uid
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
