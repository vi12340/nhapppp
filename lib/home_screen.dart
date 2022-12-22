import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_handler.dart';
import 'package:flutter_application_1/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<NotesMode>> notesList;

  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  //-------------------------
  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),

      //-----------------------------------------
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesMode>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),
                            ),
                            confirmDismiss: (direction) {
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('delete Ok?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                dbHelper!.delete(
                                                    snapshot.data![index].id!);
                                                notesList =
                                                    dbHelper!.getNotesList();

                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text('Delete')),
                                        TextButton(
                                            onPressed: (() {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            }),
                                            child: Text('Cancel'))
                                      ],
                                    );
                                  });
                            },
                            onDismissed: (direction) {
                              setState(() {
                                dbHelper!.delete(snapshot.data![index].id!);
                                snapshot.data!.remove(snapshot.data![index].id);
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                leading:
                                    Text(snapshot.data![index].id.toString()),
                                title: Text(snapshot.data![index].title),
                                subtitle:
                                    Text(snapshot.data![index].discreption),
                                trailing: Text(snapshot.data![index].email),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //   if (snapshot.hasData) {
                  //     return ListView.builder(
                  //         itemCount: snapshot.data?.length,
                  //         reverse: true,
                  //         itemBuilder: (context, index) {
                  //           return InkWell(
                  //             onTap: () {
                  //               dbHelper!.update(NotesMode(
                  //                   id: snapshot.data![index].id,
                  //                   title: 'title1',
                  //                   age: '12',
                  //                   discreption: 'discreption',
                  //                   email: 'email'));
                  //               setState(() {
                  //                 notesList = dbHelper!.getNotesList();
                  //               });
                  //             },
                  //             child: Dismissible(
                  //               direction: DismissDirection.endToStart,
                  //               background: Container(
                  //                 color: Colors.red,
                  //                 child: Icon(Icons.delete_forever),
                  //               ),
                  //               onDismissed: ((DismissDirection direction) {
                  //                 setState(() {
                  //                   dbHelper!.delete(snapshot.data![index].id!);
                  //                   notesList = dbHelper!.getNotesList();
                  //                   snapshot.data!.remove(snapshot.data![index].id);
                  //                 });
                  //               }),
                  //               key: ValueKey<int>(snapshot.data![index].id!),
                  //               child: Card(
                  //                 child: ListTile(
                  //                   contentPadding: EdgeInsets.all(0),
                  //                   title: Text(
                  //                       snapshot.data![index].title.toString()),
                  //                   subtitle: Text(snapshot.data![index].discreption
                  //                       .toString()),
                  //                   trailing:
                  //                       Text(snapshot.data![index].age.toString()),
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         });
                  //   } else {
                  //     return Center(
                  //       child: CircularProgressIndicator(),
                  //     );

                  //   },
                }),
          ),
        ],
      ),

      //------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          dbHelper!
              .insert(NotesMode(
                  title: 'title', discreption: 'discreption', email: 'email'))
              .then((value) {
            print('data add');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          });
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}
