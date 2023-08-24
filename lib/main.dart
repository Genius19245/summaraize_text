import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summaraize_text/model/date.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBa6dBOwt9DCWwi9hf2NHCdx6xGg7y8nX4",
        authDomain: "shourya-s-french-app.firebaseapp.com",
        projectId: "shourya-s-french-app",
        storageBucket: "shourya-s-french-app.appspot.com",
        messagingSenderId: "58933452989",
        appId: "1:58933452989:web:9b429015301346368517d4",
        measurementId: "G-Q0YSDVLR1F"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Summaraiser(),
    );
  }
}

class Summaraiser extends StatefulWidget {
  const Summaraiser({Key? key}) : super(key: key);

  @override
  _SummaraiserState createState() => _SummaraiserState();
}

class _SummaraiserState extends State<Summaraiser> {
  final ref = FirebaseFirestore.instance
      .collection('summarise')
      .doc('kRtv8FQ0SVKENYrxa8cr');
  final TextEditingController _textController = TextEditingController();
  String? docId;
  String? summarised_text = 'Summarise Text will appear here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text(
          "Shourya's Summaraiser",
          style: TextStyle(
            fontSize: 45,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Image.network(
                  "https://cdn-icons-png.flaticon.com/128/10321/10321207.png",
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Text(
                    summarised_text!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.white60,
                          fontWeight: FontWeight.w200,
                        ),
                        hintText: 'Type your text to summarise',
                        contentPadding:
                            const EdgeInsets.only(top: 13, left: 15),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('summarise')
                                .doc('kRtv8FQ0SVKENYrxa8cr')
                                .update({'summary': FieldValue.delete()});
                            FirebaseFirestore.instance
                                .collection('summarise')
                                .doc('kRtv8FQ0SVKENYrxa8cr')
                                .update({'status': FieldValue.delete()});
                            FirebaseFirestore.instance
                                .collection('summarise')
                                .doc('kRtv8FQ0SVKENYrxa8cr')
                                .update(
                                    {'safetyMetadata': FieldValue.delete()});
                            await ref.update(
                              {'text': _textController.text},
                            );
                            // final doc = await ref
                            //     .add(DataModel(
                            //   text: _textController.text,
                            // ).toJson())
                            //     .then((doc) async {
                            //   setState(() {
                            //     docId = doc.id;
                            //   });
                            // });
                            Future.delayed(const Duration(seconds: 5),
                                () async {
                              setState(() {
                                summarised_text = snapshot.data!['summary'];
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      _textController.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          color: Colors.deepPurpleAccent,
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        child: Center(
                            child: Text(
                          'Clear',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
