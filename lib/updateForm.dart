import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateForm extends StatefulWidget {
  final dynamic ToDoData;

  UpdateForm({required this.ToDoData});

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  CollectionReference ToDoCollection = FirebaseFirestore.instance.collection('ToDo');

  late TextEditingController durationController;
  late String status;

  @override
  void initState() {
    super.initState();
    durationController = TextEditingController(
        text: widget.ToDoData.data().containsKey('duration') ? widget.ToDoData['duration'] : '');
    status = widget.ToDoData['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Update Task',
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
                  'Update Task',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: durationController,
                  decoration: InputDecoration(
                    hintText: 'Duration (days)',
                    icon: Icon(Icons.timer),
                  ),
                ),
                SizedBox(height: 10),
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
                    ToDoCollection.doc(widget.ToDoData.id).update({
                      'duration': durationController.text,
                      'status': status,
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}