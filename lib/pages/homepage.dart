import 'package:chat_messengerapp/components/chat_post.dart';
import 'package:chat_messengerapp/components/drawer.dart';
import 'package:chat_messengerapp/components/my_textfield.dart';
import 'package:chat_messengerapp/helper/helper_methods.dart';
import 'package:chat_messengerapp/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // text controller
  final textController = TextEditingController();

  //sigOut
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //post message
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);
    // go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Social Nextwork'),
      ),
      // Drawer
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOutTap: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // Social Network
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get the message
                        final post = snapshot.data!.docs[index];
                        return ChatPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          //if u get error in this line delete the post in cloud Firestore
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['Timestamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasData) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                //run flutter pub add cloud_firestore
              ),
            ),
            // Post Message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  // textfield
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Someone Speical is wait for your text',
                      obscureText: false,
                    ),
                  ),
                  // post button
                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ),
            // logged is as
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              "Logged in as: " + currentUser.email!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
