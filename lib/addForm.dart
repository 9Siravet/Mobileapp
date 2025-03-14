import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addForm extends StatefulWidget {
  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  final titleController = TextEditingController();
  final DurationController = TextEditingController();
  String status = 'Not Completed'; // Add this line

  CollectionReference ToDo =
      FirebaseFirestore.instance.collection('ToDo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Example',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                Text(
                  'New Post',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Work To Do',
                    icon: Icon(Icons.work),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: DurationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'period : day',
                    icon: Icon(Icons.calendar_month), 
                  ),
                ),
                SizedBox(height: 10), // Add this line
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Completed'),
                      value: 'Completed',
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Not Completed'),
                      value: 'Not Completed',
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ToDo.add({
                      'title': titleController.text,
                      'duration': DurationController.text,
                      'status': status, // Add this line
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
