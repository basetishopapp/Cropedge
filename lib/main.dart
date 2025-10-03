import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // created by flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FarmEdgeApp());
}

class FarmEdgeApp extends StatelessWidget {
  const FarmEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmEdge',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const FirestoreTestPage(),
    );
  }
}

class FirestoreTestPage extends StatefulWidget {
  const FirestoreTestPage({super.key});

  @override
  State<FirestoreTestPage> createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String status = "Testing Firestore...";

  @override
  void initState() {
    super.initState();
    _testFirestore();
  }

  Future<void> _testFirestore() async {
    try {
      // Write test data
      await _db.collection('test').add({
        'message': 'Hello from FarmEdge!',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Read test data
      final snapshot = await _db.collection('test').orderBy('timestamp').limit(1).get();
      final doc = snapshot.docs.first;

      setState(() {
        status = "Firestore Connected ✅: ${doc['message']}";
      });
    } catch (e) {
      setState(() {
        status = "Firestore Error ❌: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FarmEdge Firestore Test')),
      body: Center(child: Text(status, textAlign: TextAlign.center)),
    );
  }
}
