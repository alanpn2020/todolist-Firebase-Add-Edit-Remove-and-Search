import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:listadetarefa/floatingAction.dart';
import 'package:listadetarefa/homepage.dart';

import 'PesquisaAction.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefa'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DadosPesquisa());
                }),
          ],
        ),
        body: HomePage(),
        floatingActionButton: floatingActon(),
      ),
    );
  }
}

