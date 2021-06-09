import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String keyindex; //VARIAVEL CRIADO PARA GERAR NUMERO ALEATORIO PARA O INDEX
  FirebaseFirestore db = FirebaseFirestore.instance;
  var tituloForm = TextEditingController(); //CHAVE DO FORMULARIO
  var descricaoForm = TextEditingController(); //CONTROLLER DO CAMPO TEXTO
  final keyForm = GlobalKey<FormState>(); //CONTROLLER DO CAMPO DESCRIÇÃO

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.lightBlue[400],
      child: StreamBuilder(
          stream: db
              .collection('todofirebase')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //SE APRESENTA ALGUM ERRO, APRESENTA A MENSAGEM DE ERRO
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              //SE NÃO TIVER NENHUMA CONEXÃO
              return Center(
                //APRESENTA O CIRCULO DE CARREGAMENTO
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.docs.length == 0) {
              //SE NÃO TIVER NADA NO BANCO DE DADOS, APRESENTA A MENSAGEM
              return Center(
                child: Text(
                  'Não existe anotações adicionadas!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(index.toString()),
                    onDismissed: (direction) {
                      setState(() {
                            db
                            .collection('todofirebase')
                            .doc(snapshot.data.docs[index].get('index'))
                            .delete();
                      });
                    },
                    background: Container(
                      color: Colors.yellow,
                      child: Align(
                        alignment: Alignment(-0.9, 0.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    child: Card(
                        child: Ink(
                      color: Colors.blue,
                      child: ListTile(
                        title: Text(snapshot.data.docs[index].get('title'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.odibeeSans(
                                fontSize: 20, color: Colors.blue[50])),
                        subtitle: Text(
                            snapshot.data.docs[index].get('descricao'),
                            style: GoogleFonts.odibeeSans(
                                fontSize: 20, color: Colors.blue[50])),
                        onTap: () {
                          return showDialog(
                   context: context,
                   builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: 
                      BorderRadius.circular(5.0),
                    ),
                    child: Container(
                      height: 300,
                    child: AlertDialog(
                    insetPadding: EdgeInsets.all(5.0),
                    content: Form(
                      key: keyForm,
                      child: Column(
                        children: <Widget>[
                          Text('Editar', style: TextStyle(color: Colors.red, fontSize: 20),),
                        SizedBox( height: 20,),
                          Text('Titulo'),
                          TextFormField(
                            controller: tituloForm,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Campo não preenchido';
                              }
                              return null;
                            }
                          ),
                          Text('Anotação'),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'test'),
                            controller: descricaoForm,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Campo não pode ser vazio';
                              }
                              return null;
                            }
                          ),

                        ]
                      ),
                    ),
                    actions: <Widget>[
                            FlatButton(
                              //BOTÃO FORMULARIO CANCELAR
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancelar'),
                            ),
                            FlatButton(
                            //BOTÃO FORMULARIO Salvar
                            onPressed: (){
                              
                               if (keyForm.currentState.validate()) {
                                     db  
                                      .collection('todofirebase')
                                      .doc(snapshot.data.docs[index].get('index').toString())  
                                      .set({
                                    "index": snapshot.data.docs[index].get('index').toString(),
                                    "title": tituloForm.text,
                                    "descricao": descricaoForm.text,
                                    "date": Timestamp.now(), 
                                  });
                                }
                                Navigator.of(context).pop();  //FUNÇÃO PARA FECHAR A JANELA
                                tituloForm.text = "";
                                descricaoForm.text = "";
                              },
                              color: Colors.blue, //coloca um soma no botão
                              child: Text('Salvar'),
                            ),
                    ],
                   
                    
                  )));
                });
                        },
                      ),
                    )),
                    direction: DismissDirection.startToEnd,
                  );
                });
          }),
    );
  }
}
