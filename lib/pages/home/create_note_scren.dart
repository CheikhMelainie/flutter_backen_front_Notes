// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/note/note_api.dart';
import '../../models/note_model.dart';
import '../../models/user_cubit.dart';
import '../../models/user_models.dart';
import 'home.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  late User user;
  @override
  void initState() {
    user = context.read<UserCubit>().state;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
        actions: [
          OutlinedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    noteController.text.isNotEmpty) {
                  var a = await createNote(
                    user,
                    titleController.text,
                    noteController.text,
                  );
                  if (a) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                  }
                }
              },
              child: Text(
                "Create",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder<List<Note>>(
          future: getNotes(user),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Note> notes = snapshot.data!;
            return GridView.count(crossAxisCount: 2, children: [
              ...notes.map((note) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(children: [
                    Text(note.title),
                    Text(note.author.nickname),
                    Text(
                      note.note.length > 20
                          ? note.note.substring(0, 20)
                          : note.note,
                    ),
                  ]),
                );
              }).toList(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateNoteScreen()));
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.add),
                ),
              )
            ]);
          }),
    );
  }
}
