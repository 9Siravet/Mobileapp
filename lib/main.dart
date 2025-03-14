import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/updateForm.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './addForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;

  //------ หน้าจอแต่ละหน้า ------
  final mobileScreens = [
    home(),
    search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'To-Do List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      //------ เรียกหน้าจอแต่ละหน้าตาม Index ------
      body: mobileScreens[screenIndex],

      //------ floatingActionButton ------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            screenIndex = 1;
          });
          //------ ไปหน้า addForm ------
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => addForm()))
              .then((_) {
            setState(() {
              screenIndex = 0;
            });
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //------ bottomNavigationBar ------
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(99, 136, 137, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเขียวเข้ม ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 0
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    screenIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: screenIndex == 1
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.widgets,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

//------------- Home page -------------
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference ToDo =
      FirebaseFirestore.instance.collection('ToDo');

  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: ToDo.snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    var ToDoIndex = snapshot.data!.docs[index];
                    //------------ สไลด์เมนู Slidable ------------
                    return Slidable(
                      //------ startActionPane สไลด์จากด้านซ้ายมือ ------
                      startActionPane:
                          //------ DrawerMotion รูปแบบการสไลด์ ------
                          //รูปแบบการสไลด์เพิ่มเติมที่ https://pub.dev/packages/flutter_slidable
                          ActionPane(motion: DrawerMotion(), children: [
                            //------ SlidableAction เมนูที่สไลด์เปิด ------
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.blue,
                          icon: Icons.share,
                          label: 'แชร์',
                        )
                      ]),
                      //------ endActionPane สไลด์จากด้านขวามือ ------
                      endActionPane:
                          //------ StretchMotion รูปแบบการสไลด์ ------
                          ActionPane(motion: StretchMotion(), children: [
                            //------ SlidableAction เมนูที่สไลด์เปิด ------
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateForm(ToDoData: ToDoIndex),
                                    settings:
                                        RouteSettings(arguments: ToDoIndex)));
                          },
                          backgroundColor: Colors.green,
                          icon: Icons.edit,
                          label: 'แก้ไข',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            ToDo.doc(ToDoIndex.id).delete();
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'ลบ',
                        ),
                      ]),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          title: Text(
                            ToDoIndex['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            ToDoIndex['status'],
                            style: TextStyle(
                              fontSize: 16,
                              color: ToDoIndex['status'] == 'Completed'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          trailing: Icon(
                            ToDoIndex['status'] == 'Completed'
                                ? Icons.check_circle
                                : Icons.pending,
                            color: ToDoIndex['status'] == 'Completed'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  }));
            } else {
              return Center(child: Text('No data'));
            }
          })),
    );
  }
}

//------------- Search page -------------
class search extends StatelessWidget {
  const search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Search')],
        ),
      ),
    );
  }
}
