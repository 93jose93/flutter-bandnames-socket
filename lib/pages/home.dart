import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //nuevo listado

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 3),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'AC/DC', votes: 2),
    Band(id: '4', name: 'Rammstein', votes: 5),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      //encima del buil contrl+. podemos cotruirlo rapido
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i) => _banTile(bands[i]),
          
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add),
        elevation: 1,
        //voton elevado, se a creado un metodo
        //solo referencia
        onPressed: addNewBand,
      ),
   );
  }

  //metodo
  Widget _banTile(Band band) {
    //este Dismissible es para mover de lado y borrar algo de la app
    return Dismissible(
      key: Key(band.id),
      //que solo s emueva a un solo lado
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) {
         print('direction $direction');
         print('id: ${ band.id }');
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.purple,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white),),
        )
      ),
      child: ListTile(
              leading: CircleAvatar(
                //substring muestra las primeras dos letras
                child: Text( band.name.substring(0, 2)),
                backgroundColor: Colors.blue[100],
              ),
              title: Text( band.name ),
              trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20),),
              onTap: () {
                print(band.name);
              },
            ),
    );
  }

  //metodo 
  addNewBand(){
      final textController = new TextEditingController();

      if( !Platform.isAndroid ){
          
           //mostrar un dialogo
          return showDialog(
          context: context,
          //cuando se hace un builder es que se va regresar algo, entonces por eso se usa return
          builder: (context) {
            return AlertDialog(
              title: Text('New band name:'),
              //este recibe lo que se escribe en la caja
              content: TextField(
                controller: textController,
              ),
              actions: [
                  MaterialButton(
                    child: Text('add'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => addBandToList(textController.text)
                  )
              ],
            );
          }
          );

      }

      showCupertinoDialog(
        context: context, 
        builder: ( _ ) {
          return CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
               CupertinoDialogAction(
                 isDefaultAction: true,
                 child: Text('Add'),
                 onPressed: () => addBandToList(textController.text)
               ),
                CupertinoDialogAction(
                 isDestructiveAction: true,
                 child: Text('Dismiss'),
                 onPressed: () => Navigator.pop(context)
               )
            ],
          );
        }
      );


     
  }

  //nuevo metodo para al darle al botton
  void addBandToList( String name ) {
    print(name);

    if(name.length > 1) {
      //Podemos agregarlo
      this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ));
       setState(() {});
    }

   
    //luego cerramos el dialogo
    Navigator.pop(context);
  }
}