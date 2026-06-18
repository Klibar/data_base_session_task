import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Mainscrren extends StatefulWidget {
  const Mainscrren({super.key});

  @override
  State<Mainscrren> createState() => _MainscrrenState();
}

class _MainscrrenState extends State<Mainscrren> {
  final Box imageBox = Hive.box('profileImage');
  final Box tasksBox = Hive.box('tasks');
  final Box doneTasksBox = Hive.box('doneTasks');
  final ImagePicker picker = ImagePicker();
  final TextEditingController texController = TextEditingController();
  final DateTime dateTimePicker = DateTime.now();

  Future<void> pickImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageBox.put('prfilePath', pickedFile.path);
      });
    }
  }

  void addTask() {
    if (texController.text.isNotEmpty) {
      tasksBox.add(texController.text);
      texController.clear();
      Navigator.pop(context);
    }
  }

  void removeTask(int index) {
    tasksBox.deleteAt(index);
  }

  void removeDoneTask(int index) {
    doneTasksBox.deleteAt(index);
  }

  void markAsDone(int index) {
    doneTasksBox.add(tasksBox.getAt(index));
    tasksBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    String? imagePath = imageBox.get('prfilePath');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(
          'TASKATI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          InkWell(
            onTap: pickImage,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: imagePath != null
                    ? FileImage(File(imagePath))
                    : null,
                child: imagePath == null ? Icon(Icons.add_a_photo) : null,
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context, Box box, child) {
          if (box.isEmpty && doneTasksBox.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Lottie.asset('assets/lottieAnimation.json', height: 200),
                  SizedBox(height: 20),
                  Text(
                    'No Tasks Yet 💔',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffddc4f3),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView(
            children: [
              if (box.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Active Tasks',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (BuildContext context, int index) {
                    final taskTitle = box.getAt(index).toString();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff1d1d1d),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => markAsDone(index),
                                      icon: Icon(
                                        Icons.circle_outlined,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      taskTitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy  hh:mm a',
                                  ).format(dateTimePicker),
                                ),
                                IconButton(
                                  onPressed: () => removeTask(index),
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    );
                  },
                ),
              ],
              ValueListenableBuilder(
                valueListenable: doneTasksBox.listenable(),
                builder: (BuildContext context, Box doneBox, Widget? child) {
                  if (doneBox.isEmpty) return SizedBox();
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        child: Text(
                          'Completed Tasks',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: doneBox.length,
                        itemBuilder: (BuildContext context, int index) {
                          final taskTitle = doneBox.getAt(index).toString();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xff1d1d1d),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              taskTitle,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.white,
                                                decorationThickness: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              removeDoneTask(index),
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Color(0xff1d1a23),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: .min,
                children: [
                  TextField(
                    controller: texController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Task Title',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => addTask(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff735ca4),
                          ),
                          child: Text(
                            'Save Task',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Color(0xff6b4287),
        child: Icon(Icons.add, color: Colors.white, size: 35),
      ),
    );
  }
}
