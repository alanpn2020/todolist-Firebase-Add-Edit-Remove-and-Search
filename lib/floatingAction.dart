import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class floatingActon extends StatefulWidget {
  @override
  _floatingActonState createState() => _floatingActonState();
}

class _floatingActonState extends State<floatingActon> {
  String keyindex; //VARIAVEL CRIADO PARA GERAR NUMERO ALEATORIO PARA O INDEX
  FirebaseFirestore db = FirebaseFirestore.instance;
  var tituloForm = TextEditingController(); //CHAVE DO FORMULARIO
  var descricaoForm = TextEditingController(); //CONTROLLER DO CAMPO TEXTO
  final keyForm = GlobalKey<FormState>(); //CONTROLLER DO CAMPO DESCRIÇÃO

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: (Icon(Icons.add)),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                      height: 300,
                      child: AlertDialog(
                          insetPadding: EdgeInsets.all(8.0),
                          content: Form(
                            key: keyForm, //CHAVE
                            child: Column(
                              children: <Widget>[
                                Text('Titulo'),
                                TextFormField(
                                    controller: tituloForm,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        //VALIDAÇÃO CAMPO VAZIO
                                        return 'Campo não pode ser vazio';
                                      }
                                      return null;
                                    }),
                                Text('Anotação:'),
                                TextFormField(
                                    controller: descricaoForm,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        //VALIDAÇÃO CAMPO VAZIO
                                        return 'Campo não pode ser vazio';
                                      }
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              //BOTÃO FORMULARIO CANCELAR
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancelar'),
                            ),
                            FlatButton(
                              onPressed: () {
                                //BOTÃO FORMULÁRIO SALVARA
                                if (keyForm.currentState.validate()) {
                                  keyindex = randomAlpha(
                                      20); //FUNÇÃO PARA CRIAR UM NUMERO ALEATORIO

                                      db.collection('todofirebase')
                                      .doc(keyindex.toString())
                                      .set({
                                    "index": keyindex.toString(),
                                    "title": tituloForm.text,
                                    "descricao": descricaoForm.text,
                                    "date": Timestamp.now(),
                                  });
                                }
                                Navigator.of(context)
                                    .pop(); //FUNÇÃO PARA FECHAR A JANELA
                                tituloForm.text = "";
                                descricaoForm.text = "";
                              },
                              color: Colors.pink, //coloca um soma no botão
                              child: Text('Salvar'),
                            ),
                          ])));
            });
      },
    );
  }
}
