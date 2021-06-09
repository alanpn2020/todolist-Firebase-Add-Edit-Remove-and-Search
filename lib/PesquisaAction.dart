import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DadosPesquisa extends SearchDelegate<String> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection('todofirebase')
            .where('title', isGreaterThanOrEqualTo: query )
    
            .snapshots(),
        builder: (context, snapshot) {
          print(query);
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Text('Nenhum dados no banco de dados'),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data.docs[index].get('title')),
                  subtitle: Text(snapshot.data.docs[index].get('descricao')),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
