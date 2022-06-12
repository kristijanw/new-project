import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/views/components/custom_card.dart';
import 'package:myproject/views/screens/auth/login.dart';
import 'package:myproject/views/screens/detector/pose_detector.dart';
import 'package:myproject/views/screens/todo/todo_list.dart';
import 'package:myproject/views/widgets/my_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${auth.currentUser?.email}'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const MyTitle(title: 'Fitness', size: 40),
            GestureDetector(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PoseDetectorView()  ))
              },
              child: const CustomCard(title: 'Squat'),
            ),
            const SizedBox(height: 20,),

            const MyTitle(title: 'Todo', size: 40),
            GestureDetector(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TodoList()  ))
              },
              child: const CustomCard(title: 'Start'),
            ),

          ],
        ),
      ),
    );
  }

  // Logout
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}